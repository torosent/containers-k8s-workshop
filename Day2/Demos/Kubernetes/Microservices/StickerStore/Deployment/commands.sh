#! /bin/sh

# create a secert
kubectl create -f secret.yaml

# deploy services
kubectl create -f deploy.yaml

# scale printing service to 10
kubectl scale --replicas 10 deployment printingservice-deployment

# scale printing service to 1
kubectl scale --replicas 1 deployment printingservice-deployment

# update printing service version
# cd into Printing service folder
# change the version number in printer.cs line 68

docker build -t torosent/printingservice:1.0.8 . 
docker push torosent/printingservice:1.0.8
kubectl set image deployment/printingservice-deployment printingservice=torosent/printingservice:1.0.8

 
