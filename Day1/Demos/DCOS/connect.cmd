@echo off
SET rg=dcosworkshop
SET acsname=myDCOSCluster
@echo on

@REM connect to dcos
az network public-ip list --resource-group %rg% --query "[?contains(name,'dcos-master')].[ipAddress]" -o tsv

@REM Generate you SSH private key with puttygen
@REM https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows#create-a-private-key-for-putty
putty.exe -ssh -i %userprofile%\.ssh\id_rsa.ppk -L 8080:localhost:80 azureuser@ip

@REM or using the CLI
az acs dcos browse --name $acsname --resource-group %rg% --ssh-key-file %userprofile%\.ssh\id_rsa

