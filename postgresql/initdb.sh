#!/usr/bin/env bash

apt-get update && apt-get install postgresql-14-pgoutput

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE employee_db;
    \c employee_db;
    \i home/setup.sql;
    \i home/seed.sql;

    ALTER TABLE public.employee REPLICA IDENTITY FULL;

    ALTER SYSTEM SET wal_level to 'logical';
EOSQL