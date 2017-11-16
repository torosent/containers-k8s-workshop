#! /bin/sh
. ../../../common.vars
RG="${PREFIX}-containerInstance"
CONTAINER_NAME="${PREFIX}-helloWorld"

# create resource group
az group create --name "$RG" --location "$LOCATION"

# create aci 
az container create --name "$CONTAINER_NAME" --image tutum/hello-world --resource-group "$RG" --ip-address public --ports 80

# show details and public ip
az container show --name "$CONTAINER_NAME" --resource-group "$RG"

# show logs
#az container logs --name "$CONTAINER_NAME" --resource-group "$RG"

# delete everything
#az container delete --name "$CONTAINER_NAME" --resource-group "$RG"
#az group delete -n "$RG" --yes
