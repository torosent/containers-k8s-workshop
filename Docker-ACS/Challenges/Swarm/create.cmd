@echo off
SET rg=swarmworkshop
SET acsname=mySwarmCluster
@echo on

@REM create resource group
az group create --name %rg% --location ukwest @REM Swarm mode region

@REM create swarm with generate keys
@REM az acs create --orchestrator-type DockerCE --resource-group %rg% --name %acsname% --generate-ssh-keys --agent-count 1

@REM create dcos with predefined keys
@REM https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows
az acs create --orchestrator-type DockerCE --resource-group %rg% --name %acsname% --ssh-key-value %userprofile%\.ssh\id_rsa.pub --agent-count 1 
