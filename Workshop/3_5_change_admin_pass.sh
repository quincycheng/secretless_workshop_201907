#!/bin/bash
set -euo pipefail

source bootstrap.env

export API_KEY_ADMIN=$(cat admin.key)
#$(kubectl get svc --namespace conjur \
#    conjur-oss-ingress \
#    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

docker run --rm -it --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root:z --entrypoint bash cyberark/conjur-cli:5 -c "yes yes | conjur init -a $CONJUR_ACCOUNT -u $CONJUR_URL"
docker run --rm -it --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root:z cyberark/conjur-cli:5 authn login -u admin -p $API_KEY_ADMIN
docker run --rm -it --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 user update_password -p $CONJUR_ADMIN_PASSWORD
docker run --rm -it --add-host conjur.demo.com:$SERVICE_IP -v $(pwd)/mydata/:/root cyberark/conjur-cli:5 authn logout

#cp ./mydata/conjur-$CONJUR_ACCOUNT.pem .

docker run --rm -it --add-host conjur.demo.com:$(minikube ip) \
-v $(pwd)/mydata/:/root:z --entrypoint bash cyberark/conjur-cli:5 \
-c "cat /root/conjur-default.pem" > conjur-default.pem

