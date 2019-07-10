#!/bin/bash
source bootstrap.env

export insecure_app_url=$(minikube service -n orquestador-insecure test-app-orginal  --url)
#export insecure_app_url=$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080

curl  -d "{\"name\": \"$(shuf -n 1 /usr/share/dict/words)\"}" -H "Content-Type: application/json" $insecure_app_url/pet
