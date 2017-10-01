#! /bin/sh
rg=dcosworkshop
acsname=myDCOSCluster
az group create --name  $rg --location northeurope
az acs create --orchestrator-type dcos --resource-group $rg --name  $acsname --generate-ssh-keys
ip=$(az network public-ip list --resource-group $rg --query "[?contains(name,'dcos-master')].[ipAddress]" -o tsv)
sudo ssh -i ~/.ssh/id_rsa -fNL 80:localhost:80 -p 2200 azureuser@$ip


