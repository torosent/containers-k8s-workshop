@REM create resource group
az group create --name myResourceGroup --location westeurope

@REM create aci 
az container create --name mycontainer --image tutum/hello-world --resource-group myResourceGroup --ip-address public --port 80

@REM show details and public ip
az container show --name mycontainer --resource-group myResourceGroup

@REM show logs
@REM az container logs --name mycontainer --resource-group myResourceGroup

@REM delete everything
@REM az container delete --name mycontainer --resource-group myResourceGroup
@REM az group delete -n myResourceGroup --yes
