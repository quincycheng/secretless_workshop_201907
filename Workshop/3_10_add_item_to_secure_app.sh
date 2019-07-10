#!/bin/bash

#export secure_app_url=$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080
export secure_app_url=$(minikube service -n orquestador test-app-summon-sidecar --url)


curl  -d "{\"name\": \"$(shuf -n 1 /usr/share/dict/words)\"}" -H "Content-Type: application/json" $secure_app_url/pet
