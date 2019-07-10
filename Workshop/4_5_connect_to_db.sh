#!/bin/bash


export SECURITY_ADMIN_USER=security_admin_user
export SECURITY_ADMIN_PASSWORD=security_admin_password
export REMOTE_DB_URL=$(minikube ip):30001

docker run --rm -it -e PGPASSWORD=${SECURITY_ADMIN_PASSWORD} postgres:9.6 \
  psql -U ${SECURITY_ADMIN_USER} "postgres://${REMOTE_DB_URL}/postgres" -c "\du"

