#!/bin/bash
set -e


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE ROLE okapi WITH PASSWORD 'okapi25' LOGIN SUPERUSER;
    CREATE DATABASE okapi WITH OWNER okapi;
    GRANT ALL PRIVILEGES ON DATABASE okapi TO okapi;
    CREATE ROLE folio_admin WITH PASSWORD 'folio_admin' LOGIN SUPERUSER;
    CREATE DATABASE okapi_modules WITH OWNER folio_admin;
    GRANT ALL PRIVILEGES ON DATABASE okapi_modules TO folio_admin;
EOSQL