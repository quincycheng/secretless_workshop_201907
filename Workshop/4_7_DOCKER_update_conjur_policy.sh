#!/bin/bash

source bootstrap.env

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 policy load root /root/policy/app-access2.yml

sleep 1s

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 variable values add orquestador-ajustadores-app/secretless-url "secretless-backend.orquestador.svc.cluster.local:5432"

sleep 1s

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 variable values add orquestador-ajustadores-app/secretless-username "app_user"

sleep 1s

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 variable values add orquestador-ajustadores-app/secretless-password "app_user_password"

sleep 1s

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP \
-v $(pwd)/mydata/:/root cyberark/conjur-cli:5 \
policy load conjur/authn-k8s/dev/apps /root/policy/host-policy.yml


sleep 1s

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP \
-v $(pwd)/mydata/:/root cyberark/conjur-cli:5 \
policy load root /root/policy/host-entitlement.yml

