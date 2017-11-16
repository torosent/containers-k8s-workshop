#! /bin/sh
. ../../common.vars
RG="${PREFIX}-kubeworkshop"
NAME="${PREFIX}-kubecluster"

# Creat Resource Group
az group create --name "$NAME" --location westus2

chmod +x "obtainAzureSP.sh"
./obtainAzureSP.sh
AZURE_CLIENT_ID=COPY_ME_FROM_OUTPUT
AZURE_CLIENT_SECRET=COPY_ME_FROM_OUTPUT

# Create Cluster
#az aks create --resource-group "$RG" --name "$NAME" --service-principal <client_id> --client-secret <client_secret> --agent-vm-size Standard_DS3_v2 --agent-count 2 --generate-ssh-keys -k 1.8.1
az aks create --resource-group "$RG" --name "$NAME" --service-principal "$AZURE_CLIENT_ID" --client-secret "$AZURE_CLIENT_SECRET" --agent-vm-size Standard_DS3_v2 --agent-count 2 --ssh-key-value "$SSH_PUB_KEY" -k 1.8.1

# Must for first time only ; Install Kubectl CLI. If you are using Windows than kubectl is in program files (x86). Make sure it is in your PATH variable
az aks install-cli

# Connect kubectl to cluster
az aks get-credentials --resource-group="$RG" --name="$NAME"

# Proxy to the dashboard
az aks browse --resource-group="$RG" --name="$NAME"
