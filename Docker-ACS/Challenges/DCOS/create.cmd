@REM Customize the RG and ACSNAME parameters as needed.
@echo off
SET rg=dcosworkshop
SET acsname=myDCOSCluster
@echo on

@REM create resource group
az group create --name  %rg% --location westus

@REM Create cluster with either auto-generated keys or provide your own.
@REM Ootion 1: create dcos with generate keys
az acs create --orchestrator-type dcos --resource-group %rg% --name %acsname% --generate-ssh-keys --agent-count 1

@REM Option 2: create dcos with predefined keys
@REM https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows
az acs create --orchestrator-type dcos --resource-group %rg% --name %acsname% --ssh-key-value %userprofile%\.ssh\id_rsa.pub --agent-count 1




