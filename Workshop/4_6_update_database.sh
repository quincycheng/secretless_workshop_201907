#!/bin/bash

  export SECURITY_ADMIN_USER=security_admin_user
  export SECURITY_ADMIN_PASSWORD=security_admin_password
  export REMOTE_DB_URL="$(minikube ip):30001"


  export APPLICATION_DB_NAME=quick_start_db

  export APPLICATION_DB_USER=app_user
  export APPLICATION_DB_INITIAL_PASSWORD=app_user_password


  docker run --rm -i -e PGPASSWORD=${SECURITY_ADMIN_PASSWORD} postgres:9.6 \
      psql -U ${SECURITY_ADMIN_USER} "postgres://${REMOTE_DB_URL}/postgres" \
      << EOSQL

  CREATE DATABASE ${APPLICATION_DB_NAME};

  /* connect to it */

  \c ${APPLICATION_DB_NAME};

  CREATE TABLE pets (
    id serial primary key,
    name varchar(256)
  );

  /* Create Application User */

  CREATE USER ${APPLICATION_DB_USER} PASSWORD '${APPLICATION_DB_INITIAL_PASSWORD}';

  /* Grant Permissions */

  GRANT SELECT, INSERT ON public.pets TO ${APPLICATION_DB_USER};
  GRANT USAGE, SELECT ON SEQUENCE public.pets_id_seq TO ${APPLICATION_DB_USER};

EOSQL

