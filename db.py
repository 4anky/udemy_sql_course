from sqlalchemy import create_engine, text
from testcontainers.postgres import PostgresContainer


_NORTHWIND_FILE_PATH = 'northwind.sql'
"""Path to the Script which contains Northwind data."""


def _receive_northwind_query() -> str:
    """
    Extracts db query from file and returns it.
    """

    with open(_NORTHWIND_FILE_PATH) as sql_file:
        return sql_file.read()


def run_northwind() -> None:
    """
    Runs docker container of Postgres, fills one
    by data of 'Northwind' company and then allows
    to execute an SQL queries. If program is stopped
    then postgres container will be removed.
    """

    with PostgresContainer() as postgres:
        engine = create_engine(postgres.get_connection_url())
        with engine.connect() as connection:
            connection.execute(
                text(_receive_northwind_query())
            )
            connection.commit()

        print('Postgres is ready!')
        while True:
            pass


if __name__ == '__main__':
    run_northwind()
