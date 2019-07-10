#!/bin/bash

#export secure_app_url=$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080

export secure_app_url=$(minikube service -n orquestador test-app-summon-sidecar --url)

curl $secure_app_url/pets
