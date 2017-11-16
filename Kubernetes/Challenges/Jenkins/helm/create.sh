#! /bin/sh

kubectl create -f jenkins-storage.yaml
helm install --name jenkins-release -f values.yaml  stable/jenkins