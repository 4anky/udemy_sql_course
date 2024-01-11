run:
	DOCKER_HOST=unix:///Users/vladimir/.colima/default/docker.sock \
	TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock \
	TC_MAX_TRIES=20 \
	POSTGRES_USER=vladimir \
	POSTGRES_PASSWORD=qwerty \
	POSTGRES_DB=northwind \
	python3.12 main.py
