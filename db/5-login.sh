#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- add type
  CREATE TYPE basic_auth.jwt_token AS (
    token text
  );

  -- login should be on your exposed schema
  create or replace function ${PGRST_DB_SCHEMA}.login(email text, pass text) returns basic_auth.jwt_token as \$\$
  declare
    _role name;
    result basic_auth.jwt_token;
  begin
    -- check email and password
    select basic_auth.user_role(email, pass) into _role;
    if _role is null then
      raise invalid_password using message = 'invalid user or password';
    end if;

    select sign(
        row_to_json(r), '${SECRET_TOKEN}'
      ) as token
      from (
        select _role as role, login.email as email,
           extract(epoch from now())::integer + 60*60 as exp
      ) r
      into result;
    return result;
  end;
  \$\$ language plpgsql security definer;

  grant execute on function ${PGRST_DB_SCHEMA}.login(text,text) to ${PGRST_DB_ANON_ROLE};


  CREATE VIEW ${PGRST_DB_SCHEMA}.users AS (
    SELECT email, role, name FROM basic_auth.users WHERE email = current_setting('request.jwt.claims', true)::json->>'email'
  );

  GRANT SELECT ON TABLE ${PGRST_DB_SCHEMA}.users TO ${PGRST_DB_ANON_ROLE};
  GRANT ALL ON TABLE ${PGRST_DB_SCHEMA}.users TO ${ROLE_USER};
EOSQL
