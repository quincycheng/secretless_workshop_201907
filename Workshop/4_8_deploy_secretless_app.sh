#!/bin/bash

source bootstrap.env

kubectl create configmap secretless-config --from-file=test-app/secretless.yml

  export conjur_authenticator_url=$CONJUR_URL/authn-k8s/$AUTHENTICATOR_ID
  sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g"  ./test-app/manifest-secretless.yml |
  sed -e "s#{{ CONJUR_APPLIANCE_URL }}#$CONJUR_URL#g" |
  sed -e "s#{{ CONJUR_AUTHN_URL }}#$conjur_authenticator_url#g" |
  sed -e "s#{{ SERVICE_IP }}#$SERVICE_IP#g" |
  kubectl create -f -

