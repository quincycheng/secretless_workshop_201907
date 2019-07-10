#!/bin/bash

echo "current time $(date)"
kubectl exec $(kubectl get pods |  grep "test-app" |  awk '{ print $1 }') cat /run/conjur/access-token

