#!/bin/bash
source bootstrap.env

#export insecure_app_url=$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080
export insecure_app_url=$(minikube service -n orquestador-insecure test-app-orginal  --url)

curl $insecure_app_url/pets
