#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- We put things inside the basic_auth schema to hide
  -- them from public view. Certain public procs/views will
  -- refer to helpers and tables inside.
  create schema if not exists basic_auth;

  create table if not exists
  basic_auth.users (
    email    text primary key check ( email ~* '^.+@.+\..+$' ),
    pass     text not null check (length(pass) < 512),
    role     name not null check (length(role) < 512),
    name     text not null
  );
  ALTER TABLE basic_auth.users ENABLE ROW LEVEL SECURITY;
  CREATE POLICY owner_policy ON basic_auth.users USING (email = current_user) WITH CHECK (email = current_user);

  create or replace function
  basic_auth.check_role_exists() returns trigger as \$\$
  begin
    if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
      raise foreign_key_violation using message =
        'unknown database role: ' || new.role;
      return null;
    end if;
    return new;
  end
  \$\$ language plpgsql;

  drop trigger if exists ensure_user_role_exists on basic_auth.users;
  create constraint trigger ensure_user_role_exists
    after insert or update on basic_auth.users
    for each row
    execute procedure basic_auth.check_role_exists();

  create or replace function
  basic_auth.encrypt_pass() returns trigger as \$\$
  begin
    if tg_op = 'INSERT' or new.pass <> old.pass then
      new.pass = crypt(new.pass, gen_salt('bf'));
    end if;
    return new;
  end
  \$\$ language plpgsql;

  drop trigger if exists encrypt_pass on basic_auth.users;
  create trigger encrypt_pass
    before insert or update on basic_auth.users
    for each row
    execute procedure basic_auth.encrypt_pass();

  create or replace function
  basic_auth.user_role(email text, pass text) returns name
    language plpgsql
    as \$\$
  begin
    return (
    select role from basic_auth.users
     where users.email = user_role.email
       and users.pass = crypt(user_role.pass, users.pass)
    );
  end;
  \$\$;

  INSERT INTO basic_auth.users VALUES ('${PGADMIN_DEFAULT_EMAIL}', '${PGADMIN_DEFAULT_PASSWORD}', 'web_user', 'CAP ZRP');
EOSQL
