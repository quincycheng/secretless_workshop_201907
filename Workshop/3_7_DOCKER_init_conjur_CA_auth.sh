#!/bin/bash

source bootstrap.env

#export SERVICE_IP=$(kubectl get svc --namespace conjur \
#                                          conjur-oss-ingress \
#                                          -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

## inicializa CA y almacena llaves en conjur

cp startCA.sh mydata/startCA.sh
cp conjur-default.pem mydata/conjur-default.pem

docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 authn login -u admin -p $CONJUR_ADMIN_PASSWORD
docker run --rm -it --network host --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root -e AUTHENTICATOR_ID -e CONJUR_ACCOUNT  \
        --entrypoint bash cyberark/conjur-cli:5 /root/startCA.sh

