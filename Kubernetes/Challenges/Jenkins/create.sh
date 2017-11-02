#! /bin/sh

vmname="jenkinscicd"
rg="jenkins-RG"
user="azureuser"
ssh="~/.ssh/id_rsa.pub"
location="northeurope"
size="Standard_D2S_V3"

az group create -n $rg -l $location
az vm create -n $vmname -g $rg --image UbuntuLTS --size $size --admin-username $user --ssh-key-value $ssh --public-ip-address-allocation static --nsg-rule SSH
az vm extension set --resource-group $rg --vm-name $vmname --name customScript --publisher Microsoft.Azure.Extensions --settings ./jenkins-config.json

az vm restart -n $vmname -g $rg 

ssh -L 127.0.0.1:8080:localhost:8080 azureuser@<ip>
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword