#! /bin/sh

# deploy services
kubectl create -f deploy.yaml

# update printing service
kubectl set image deployment/printingservice-deployment printingservice=torosent/printingservice:1.0.7