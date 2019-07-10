#!/bin/bash


cat << EOF > pg.yml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: pg
  labels:
    app: secretless-backend
spec:
  serviceName: secretless-backend
  selector:
    matchLabels:
      app: secretless-backend
  template:
    metadata:
      labels:
        app: secretless-backend
    spec:
      securityContext:
        fsGroup: 999
      containers:
      - name: secretless-backend
        image: postgres:9.6
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 5432
        env:
          - name: POSTGRES_DB
            value: postgres
          - name: POSTGRES_USER
            value: security_admin_user
          - name: POSTGRES_PASSWORD
            value: security_admin_password
        volumeMounts:
        - name: backend-certs
          mountPath: "/etc/certs/"
          readOnly: true
        args: ["-c", "ssl=on", "-c", "ssl_cert_file=/etc/certs/server.crt", "-c", "ssl_key_file=/etc/certs/server.key"]
      volumes:
      - name: backend-certs
        secret:
          secretName: secretless-backend-certs
          defaultMode: 384
EOF

kubectl apply -f pg.yml

