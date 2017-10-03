#! /bin/sh

# create a secert
kubectl create -f secret.yaml

# deploy services
kubectl create -f deploy.yaml