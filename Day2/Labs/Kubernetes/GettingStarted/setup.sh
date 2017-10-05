#! /bin/sh

# Creat Resource Group
az group create --name myK8sCluster --location northeurope

# Create Cluster
az acs create --orchestrator-type kubernetes --resource-group myK8sCluster --name myK8sCluster --service-principal <client_id> --client-secret <client_secret> --agent-vm-size Standard_DS3_v2 --generate-ssh-keys --orchestrator-release 1.7

# Must for first time only ; Install Kubectl CLI
az acs kubernetes install-cli

# Connect kubectl to cluster
az acs kubernetes get-credentials --resource-group=myK8sCluster --name=myK8sCluster

# Proxy to the dashboard
kubectl proxy