#!/bin/bash
set -euo pipefail

source bootstrap.env

## installing using helm
##

##creating namespace
if ! kubectl get namespace $CONJUR_NAMESPACE > /dev/null
then
    kubectl create namespace "$CONJUR_NAMESPACE"

fi

#helm init
#kubectl create serviceaccount --namespace kube-system tiller || true
#kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller || true
#helm init --service-account tiller --upgrade || true

#helm repo add cyberark https://cyberark.github.io/helm-charts || true
#helm repo update || true

echo "Wait for 5 seconds"

sleep 5s

helm install cyberark/conjur-oss \
    --set ssl.hostname=$CONJUR_HOSTNAME_SSL,dataKey="$(docker run --rm cyberark/conjur data-key generate)",authenticators="authn-k8s/dev\,authn" \
    --namespace "$CONJUR_NAMESPACE" \
    --name "$CONJUR_APP_NAME"

#helm install cyberark/conjur-oss \
#    --set ssl.hostname=$CONJUR_HOSTNAME_SSL,dataKey="$(docker run --rm cyberark/conjur data-key generate)",authenticators="authn-k8s/dev\,authn",serviceAccount.name=$CONJUR_SERVICEACCOUNT_NAME,serviceAccount.create=false \
#    --namespace "$CONJUR_NAMESPACE" \
#    --name "$CONJUR_APP_NAME"

echo "Wait for 5 seconds"
sleep 5s

kubectl get svc  conjur-oss-ingress -n $CONJUR_NAMESPACE
