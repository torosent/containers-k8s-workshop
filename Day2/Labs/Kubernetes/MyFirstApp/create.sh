# /bin/sh

# create the MyFirstApp deployment
kubectl create -f deployment.yaml

# expose the deployment with a service
kubectl create -f service.yaml

# describe the service and the deployment
kubectl describe service
kubectl describe deployment
