#!/bin/bash

openssl req -new -x509 -days 365 -nodes -text -out server.crt \
  -keyout server.key -subj "/CN=pg"
chmod og-rwx server.key

kubectl create secret generic \
  secretless-backend-certs \
  --from-file=server.crt \
  --from-file=server.key

