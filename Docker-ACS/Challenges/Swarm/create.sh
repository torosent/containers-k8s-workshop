#! /bin/sh
. ../../../common.vars
RG="${PREFIX}-swarmworkshop"
ACSNAME="${PREFIX}-mySwarmCluster"

# create resource group
az group create --name "$RG" --location ukwest //Swarm mode region

# create swarm with generate keys
# az acs create --orchestrator-type DockerCE --resource-group "$RG" --name "$ACSNAME" --generate-ssh-keys --agent-count 1

# create swarm with predefined keys
az acs create --orchestrator-type DockerCE --resource-group "$RG" --name "$ACSNAME" --ssh-key-value "$SSH_PUB_KEY" --agent-count 1