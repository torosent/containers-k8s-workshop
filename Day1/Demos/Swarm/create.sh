#! /bin/sh
rg=swarmworkshop
acsname=mySwarmCluster

# create resource group
az group create --name  $rg --location ukwest //Swarm mode region

# create swarm with generate keys
# az acs create --orchestrator-type DockerCE --resource-group $rg --name  $acsname --generate-ssh-keys --agent-count 1

# create swarm with predefined keys
az acs create --orchestrator-type DockerCE --resource-group $rg --name  $acsname --ssh-key-value ~/.ssh/id_rsa.pub --agent-count 1 