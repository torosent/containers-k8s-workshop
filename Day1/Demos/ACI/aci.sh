az group create --name myResourceGroup --location westeurope
az container create --name mycontainer --image microsoft/aci-helloworld --resource-group myResourceGroup --ip-address public
az container show --name mycontainer --resource-group myResourceGroup
az container logs --name mycontainer --resource-group myResourceGroup
az container delete --name mycontainer --resource-group myResourceGroup
