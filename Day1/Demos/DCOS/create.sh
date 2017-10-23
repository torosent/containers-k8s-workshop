#! /bin/sh
rg=dcosworkshop
acsname=myDCOSCluster

# create resource group
az group create --name  $rg --location northeurope

# create dcos with generate keys
#az acs create --orchestrator-type dcos --resource-group $rg --name  $acsname --generate-ssh-keys --agent-count 1

# create dcos with predefined keys
az acs create --orchestrator-type dcos --resource-group $rg --name  $acsname --ssh-key-value /users/torosent/.ssh/id_rsa.pub --agent-count 1



