#!/bin/bash 

## elimina el namespace de la app de prueba pets y todos sus servicios y deployments 
##
set -euo pipefail

kubectl delete namespace $TEST_APP_NAMESPACE_NAME


echo "Test app environment purged."