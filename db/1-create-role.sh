#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  create role authenticator noinherit login password '${SECRET_TOKEN}';

  create role ${PGRST_DB_ANON_ROLE} nologin;
  grant usage on schema ${PGRST_DB_SCHEMA} to ${PGRST_DB_ANON_ROLE};
  grant ${PGRST_DB_ANON_ROLE} to authenticator;
  grant select on ${PGRST_DB_SCHEMA}.actors to ${PGRST_DB_ANON_ROLE};

  create role ${ROLE_USER} nologin;
  grant ${ROLE_USER} to authenticator;
  grant usage on schema ${PGRST_DB_SCHEMA} to ${ROLE_USER};
  grant all on ${PGRST_DB_SCHEMA}.actors to ${ROLE_USER};
EOSQL
