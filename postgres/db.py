"""
Module describes entrypoint function and function
which tries to get the query to fill database.
"""

from sqlalchemy import create_engine, text
from testcontainers.postgres import PostgresContainer

from settings import NORTHWIND_FILE_PATH, PORT


__all__ = ("run",)


def _receive_northwind_query() -> str:
    """
    Extracts db query from file and returns it.
    """

    with open(NORTHWIND_FILE_PATH, encoding="utf-8") as sql_file:
        return sql_file.read()


def run() -> None:
    """
    Runs docker container of Postgres, fills one
    by data of 'Northwind' company and then allows
    to execute an SQL queries. If program is stopped
    then postgres container will be removed.
    """

    with PostgresContainer(port=PORT).with_bind_ports(PORT, host=PORT) as postgres:
        engine = create_engine(postgres.get_connection_url())
        with engine.connect() as connection:
            connection.execute(text(_receive_northwind_query()))
            connection.commit()

        print("Postgres is launched!")

        while True:
            pass
