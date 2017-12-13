#! /bin/sh
# LOCATION NOTE: AKS is not yet available in all regions. It's recommended to check the region availability before indicating the location of your resource group. https://azure.microsoft.com/en-us/regions/services/

# Creat Resource Group
az group create --name myK8sCluster --location centralus

# Create Cluster
#az aks create --resource-group myK8sCluster --name myK8sCluster --service-principal <client_id> --client-secret <client_secret> --node-vm-size Standard_DS3_v2 --node-count 2 --generate-ssh-keys -k 1.8.1
az aks create --resource-group myK8sCluster --name myK8sCluster --service-principal <appID> --client-secret <password> --node-vm-size Standard_DS3_v2 --node-count 2 --ssh-key-value ~/.ssh/id_rsa.pub -k 1.8.1

# Must for first time only ; Install Kubectl CLI. If you are using Windows than kubectl is in program files (x86). Make sure it is in your PATH variable
az aks install-cli

# Connect kubectl to cluster
az aks get-credentials --resource-group=myK8sCluster --name=myK8sCluster

# Proxy to the dashboard
az aks browse --resource-group=myK8sCluster --name=myK8sCluster
