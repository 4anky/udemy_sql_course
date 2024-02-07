run:
	python3.12 postgres/main.py

colima:
	colima stop && \
	colima start --network-address

pylint:
	pylint postgres

black:
	black postgres

mypy:
	mypy postgres
