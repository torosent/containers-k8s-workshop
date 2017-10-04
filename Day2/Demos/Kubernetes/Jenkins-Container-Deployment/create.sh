#! /bin/sh

#create premium storage account in Azure for attached disks
az storage account create -n myK8sClusterDisks -g myK8sCluster -l northeurope --sku Premium_LRS

# create storage disk for Jenkins
kubectl create -f k8s-jenkins-storage-disk.yaml

# Making sure the claim is provisioned. Also check the Azure Portal Storage account
kubectl describe pvc jenkinsclaim

# create jenkins deployment
kubectl create -f k8s-jenkins.yaml
kubectl get services
kubectl get pods
kubectl logs deployment/jenkins
#kubectl run curl --image=radial/busyboxplus:curl -i --tty