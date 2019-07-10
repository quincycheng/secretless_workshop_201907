#!/bin/bash

sudo rm -rf mydata
rm admin.key
rm conjur-default.pem
mkdir mydata

helm del --purge conjur-oss

kubectl delete namespace orquestador-insecure
kubectl delete namespace conjur
kubectl delete namespace orquestador
