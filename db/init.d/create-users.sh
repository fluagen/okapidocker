#!/bin/bash
set -e


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER okapi WITH PASSWORD 'okapi25';
    CREATE DATABASE okapi;
    GRANT ALL PRIVILEGES ON DATABASE okapi TO okapi;
EOSQL