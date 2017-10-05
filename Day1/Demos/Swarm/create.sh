#! /bin/sh
rg=swarmworkshop
acsname=mySwarmCluster

# create resource group
az group create --name  $rg --location northeurope

# create swarm with generate keys
az acs create --orchestrator-type Swarm --resource-group $rg --name  $acsname --generate-ssh-keys

# create swarm with predefined keys
az acs create --orchestrator-type Swarm --resource-group $rg --name  $acsname --ssh-key-value /users/torosent/.ssh/id_rsa.pub