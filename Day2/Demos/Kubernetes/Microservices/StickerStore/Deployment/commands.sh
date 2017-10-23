#! /bin/sh


# build containers
docker build -t torosent/webstore:1.0.0 .
docker build -t torosent/statusservice:1.0.0 .
docker build -t torosent/printingservice:1.0.0 .
docker build -t torosent/orderservice:1.0.0 .

docker push torosent/webstore:1.0.0
docker push torosent/printingservice:1.0.0
docker push torosent/statusservice:1.0.0
docker push torosent/orderservice:1.0.0

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

docker build -t torosent/printingservice:1.0.1 . 
docker push torosent/printingservice:1.0.1
kubectl set image deployment/printingservice-deployment printingservice=torosent/printingservice:1.0.1
kubectl rollout history deployment/printingservice-deployment
kubectl rollout undo deployment/printingservice-deployment --to-revision=1
 
