"""Module for variables storing."""

from os import environ
from os.path import join
from types import MappingProxyType

from dotenv import load_dotenv


load_dotenv()

NORTHWIND_FILE_PATH: str = join("postgres", "northwind.sql")
"""Path to the Script which contains Northwind data."""

DB_CONFIG: MappingProxyType[str, str | int] = MappingProxyType(
    {
        "port": int(environ["POSTGRES_PORT"]),  # may be deployment error if port!= 5432
        "user": environ["POSTGRES_USER"],
        "password": environ["POSTGRES_PASSWORD"],
        "dbname": environ["POSTGRES_DB"],
    }
)
