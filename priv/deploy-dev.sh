#!/bin/sh

kubectl delete deploy/web0-dev
kubectl delete svc/web0-dev
kubectl create -f priv/deploy-dev.yaml

# No kubectl path for ingress, just delete and create again
kubectl delete ing/davidhuang-top-ingress 
kubectl create -f priv/ingress.yaml