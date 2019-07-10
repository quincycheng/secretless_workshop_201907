#!/bin/bash

cat << EOF > pg-service.yml
kind: Service
apiVersion: v1
metadata:
  name: secretless-backend
spec:
  selector:
    app: secretless-backend
  ports:
    - port: 5432
      targetPort: 5432
      nodePort: 30001
  type: NodePort

EOF
kubectl apply -f pg-service.yml

