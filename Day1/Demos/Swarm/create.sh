#! /bin/sh
rg=swarmworkshop
acsname=mySwarmCluster
az group create --name  $rg --location northeurope
az acs create --orchestrator-type Swarm --resource-group $rg --name  $acsname --generate-ssh-keys
#ip=$(az network public-ip list --resource-group $rg --query "[?contains(name,'master-ip')].[ipAddress]" -o tsv)
#sudo ssh -i ~/.ssh/id_rsa -fNL 80:localhost:80 -p 2200 azureuser@$ip