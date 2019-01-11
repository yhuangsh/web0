#!/bin/sh

kubectl replace -f priv/deploy-dev.yaml

# No kubectl path for ingress, just delete and create again
#kubectl delete ing/davidhuang-top-ingress 
#kubectl create -f priv/ingress.yaml