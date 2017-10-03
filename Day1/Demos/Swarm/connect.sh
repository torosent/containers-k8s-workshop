#! /bin/sh
rg=swarmworkshop
acsname=mySwarmCluster
ip=$(az network public-ip list -g $rg --query "[?contains(name,'master-ip')].[ipAddress]" -o tsv)
sudo ssh -i azureuser@$ip 2200