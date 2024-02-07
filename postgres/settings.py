"""Module for variables storing."""

from os import environ
from os.path import join


NORTHWIND_FILE_PATH: str = join("postgres", "northwind.sql")
"""Path to the Script which contains Northwind data."""

PORT: int = int(environ["POSTGRES_PORT"])
"""Port for container and host. Is used to expose."""
