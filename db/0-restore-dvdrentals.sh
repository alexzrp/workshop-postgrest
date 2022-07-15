#!/bin/bash
set -e

pg_restore --username "$POSTGRES_USER" --no-password --dbname "$POSTGRES_DB" --verbose "/dump/dvdrental.tar"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA api AUTHORIZATION postgres;
    CREATE VIEW api.actors AS
       SELECT actor.actor_id,
          actor.first_name,
          actor.last_name
         FROM public.actor;

    ALTER TABLE api.actors OWNER TO postgres;
EOSQL
