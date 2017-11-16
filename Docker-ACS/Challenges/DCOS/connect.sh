#! /bin/sh
. ../../../common.vars
RG="${PREFIX}-dcosworkshop"
ACSNAME="${PREFIX}-myDCOSCluster"

# connect to dcos -- pull the URL from your Azure portal
ssh -i "$SSH_PRIV_KEY" -fNL 8083:localhost:80 -p 2200 YOURID.LOCATION.cloudapp.azure.com

# or using the CLI
az acs dcos browse --name "$ACSNAME" --resource-group "$RG" --ssh-key-file "$SSH_PRIV_KEY"

