#!/bin/bash
set -euo pipefail


eval $(minikube docker-env)
source bootstrap.env

export TEST_APP_NAMESPACE_NAME=${TEST_APP_NAMESPACE_NAME}-insecure

echo "Creating Test App namespace."

if ! kubectl get namespace $TEST_APP_NAMESPACE_NAME > /dev/null
then
    kubectl create namespace $TEST_APP_NAMESPACE_NAME
fi

kubectl config set-context $(kubectl config current-context) --namespace=$TEST_APP_NAMESPACE_NAME

echo "Build test app image"

pushd test-app/pg
    docker build -t test-app-pg:$CONJUR_NAMESPACE .
    test_app_pg_image=test-app-pg
    docker tag test-app-pg:$CONJUR_NAMESPACE $test_app_pg_image
popd

echo "Deploying test app Backend"

sed -e "s#{{ TEST_APP_PG_DOCKER_IMAGE }}#$test_app_pg_image#g" ./test-app/pg/postgres.yml |
  sed -e "s#{{ TEST_APP_NAMESPACE_NAME }}#$TEST_APP_NAMESPACE_NAME#g" |
  kubectl create -f -

echo "Building test app image"

pushd test-app
    docker build -t test-app:$CONJUR_NAMESPACE -f Dockerfile .
    test_app_image=test-app
    docker tag test-app:$CONJUR_NAMESPACE $test_app_image
popd

echo "Deploying test app FrontEnd"

sed -e "s#{{ TEST_APP_DOCKER_IMAGE }}#$test_app_image#g" ./test-app/test-app.yml |
    sed -e "s#{{ TEST_APP_NAMESPACE_NAME }}#$TEST_APP_NAMESPACE_NAME#g" |
    kubectl create -f -

#echo "Waiting for services to become available"
#while [ -z "$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }')" ]; do
#    printf "."
#    sleep 1
#done

echo -e "Wait for 10 seconds\n"
sleep 10s

#kubectl describe service test-app | grep 'LoadBalancer Ingress'
#app_url=$(kubectl describe service test-app | grep 'LoadBalancer Ingress' | awk '{ print $3 }'):8080
app_url=$(minikube service -n orquestador-insecure test-app-orginal  --url)

echo -e "Adding entry to the app\n"
curl  -d '{"name": "Insecure App"}' -H "Content-Type: application/json" $app_url/pet
