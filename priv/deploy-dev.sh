#!/bin/sh

kubectl delete sts/web0
kubectl delete svc/web0
kubectl create -f priv/deploy-dev.yaml

# No kubectl path for ingress, just delete and create again
kubectl delete ing/davidhuang-top-ingress 
kubectl create -f priv/ingress.yaml