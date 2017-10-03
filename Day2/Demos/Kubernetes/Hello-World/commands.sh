#! /bin/sh

# Create V1 template
kubectl create -f templateV1.yaml

# Show pods
kubectl get pods -l app=nginx

# Describe specific pod
kubectl describe pod <pod-name>

# Update V2 template 
kubectl apply -f templateV2.yaml

# Show pods
kubectl get pods -l app=nginx

# Describe specific pod
kubectl describe pod <pod-name>

# Update V2 template
kubectl apply -f templateV3.yaml

# Show pods
kubectl get pods -l app=nginx
