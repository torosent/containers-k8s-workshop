#! /bin/sh

# create resource group
az group create --name myResourceGroup --location westus

# create aci 
az container create --name mycontainer --image tutum/hello-world --resource-group myResourceGroup --ip-address public --ports 80

# show details and public ip
az container show --name mycontainer --resource-group myResourceGroup

# show logs
#az container logs --name mycontainer --resource-group myResourceGroup

# delete everything
#az container delete --name mycontainer --resource-group myResourceGroup
#az group delete -n myResourceGroup --yes
