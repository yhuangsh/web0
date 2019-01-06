#!/bin/sh

kubectl delete deploy/web0-dev
kubectl delete svc/web0-dev
kubectl create -f priv/deploy-dev.yaml