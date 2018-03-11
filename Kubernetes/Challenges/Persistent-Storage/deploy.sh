#! /bin/sh

# deploy storage
kubectl create -f deployment-storage.yaml
kubectl get pv

# check if pvc has successfully been deployed
kubectl get pvc
kubectl describe pvc

# add secret for MySQL
kubectl create secret generic mysql-pass --from-literal=password=P@ssw0rd1234
kubectl get secrets

# deploy MySQL
kubectl create -f deployment-mysql.yaml
kubectl get pods

# deploy Wordpress
kubectl create -f deployment-wordpress.yaml
kubectl get services wordpress


