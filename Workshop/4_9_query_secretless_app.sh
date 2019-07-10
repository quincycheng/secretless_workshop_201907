#!/bin/bash

#export secretless_app_url=$(kubectl describe service test-app-secretless | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080

export secretless_app_url=$(minikube service -n orquestador test-app-secretless  --url)


curl $secretless_app_url/pets

