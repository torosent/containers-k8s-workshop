#! /bin/sh

# deploy storage
kubectl create -f deployment-storage.yaml

# add secret for MySQL
kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD

# deploy MySQL
kubectl create -f deployment-mysql.yaml

# deploy Wordpress
kubectl create -f deployment-wordpress.yaml

