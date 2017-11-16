#! /bin/sh
. ../../../common.vars
RG="${PREFIX}-dcosworkshop"
ACSNAME="${PREFIX}-myDCOSCluster"

# create resource group
az group create --name "$RG" --location "$LOCATION"

# create dcos with generate keys
#az acs create --orchestrator-type dcos --resource-group "$RG" --name "$ACSNAME" --generate-ssh-keys --agent-count 1

# create dcos with predefined keys
az acs create --orchestrator-type dcos --resource-group "$RG" --name "$ACSNAME" --ssh-key-value "$SSH_PUB_KEY" --agent-count 1