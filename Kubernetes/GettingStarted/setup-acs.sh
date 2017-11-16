#! /bin/sh
. ../../common.vars
RG="${PREFIX}-kubeworkshop"
NAME="${PREFIX}-kubecluster"

# Creat Resource Group
az group create --name "$NAME" --location "$LOCATION"


# If you do not have an SSH keys, replace --ssh-key-value "$SSH_PUB_KEY" with --generate-ssh-keys

## START IF ##
## OPTION A: Create Cluster - if you are an Azure sub owner

az acs create --orchestrator-type kubernetes --resource-group "$RG" --name "$NAME" --agent-vm-size Standard_DS3_v2 --agent-count 2 --ssh-key-value "$SSH_PUB_KEY"

## OPTION B: Create Cluster - if you are NOT an Azure sub owner
chmod +x "obtainAzureSP.sh"
./obtainAzureSP.sh

AZURE_CLIENT_ID="COPY_ME_FROM_obtainAzureSP_OUTPUT"
AZURE_CLIENT_SECRET="COPY_ME_FROM_obtainAzureSP_OUTPUT"

az acs create --orchestrator-type kubernetes --resource-group "$RG" --name "$NAME" --agent-vm-size Standard_DS3_v2 --agent-count 2 --ssh-key-value "$SSH_PUB_KEY" --service-principal "$AZURE_CLIENT_ID" --client-secret "$AZURE_CLIENT_SECRET"

## ENDIF ##

# Must for first time only ; Install Kubectl CLI. If you are using Windows than kubectl is in program files (x86). Make sure it is in your PATH variable
az acs kubernetes install-cli

# Connect kubectl to cluster
az acs kubernetes get-credentials --resource-group="$RG" --name="$NAME" --ssh-key-file "$SSH_PRIV_KEY"

# Proxy to the dashboard
kubectl proxy

# Now browse to
# http://127.0.0.1:8001/ui