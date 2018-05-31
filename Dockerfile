FROM mysql:8.0
ENV MYSQL_ROOT_PASSWORD 123qwe

COPY init/user.sql /docker-entrypoint-initdb.d/
COPY init/database.sql /docker-entrypoint-initdb.d/
