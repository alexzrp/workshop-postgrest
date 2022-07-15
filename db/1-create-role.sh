#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  create role authenticator noinherit login password '${SECRET_TOKEN}';

  create role web_anon nologin;
  grant usage on schema api to web_anon;
  grant web_anon to authenticator;
  grant select on api.actors to web_anon;

  create role web_user nologin;
  grant web_user to authenticator;
  grant usage on schema api to web_user;
  grant all on api.actors to web_user;
EOSQL
