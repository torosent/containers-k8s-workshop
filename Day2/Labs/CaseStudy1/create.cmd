@echo off
SET vmname="jenkinscicd"
SET rg="jenkins-RG"
SET user="azureuser"
SET ssh=%userprofile%\.ssh\id_rsa.pub
SET location="northeurope"
SET size="Standard_D2S_V3"
@echo on

@REM Create resource group
az group create --name %rg% --location %location%

@REM Create Jenkins VM
az vm create -n %vmname% -g %rg% --image UbuntuLTS --size %size% --admin-username %user% --ssh-key-value %ssh% --public-ip-address-allocation static --nsg-rule SSH

@REM Execute VM Extension - Configures Jenkins
az vm extension set --resource-group %rg% --vm-name %vmname% --name customScript --publisher Microsoft.Azure.Extensions --settings .\jenkins-config.json

@REM Restart Jenkins VM
az vm restart -n %vmname% -g %rg% 

@REM retrive Jenkins provisioned administrator password
@REM Generate you SSH private key with puttygen (ppk)
@REM https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows#create-a-private-key-for-putty

putty.exe -ssh -i %userprofile%\.ssh\id_rsa.ppk -L 8080:localhost:8080 %user%@<ip>
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword