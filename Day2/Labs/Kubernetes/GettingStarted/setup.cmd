@echo off
SET rg=myK8sRG
SET k8sname=myK8sCluster
SET hname=dg-release 
SET location=dg-northeurope 
SET serviceprincipal=<client_id> 
SET clientsecret=<client_secret> 
@echo on

@REM Creat Resource Group
az group create --name %rg% --location %location%

@REM Create Cluster
@REM az acs create --orchestrator-type kubernetes --resource-group %rg% --name %k8sname% --service-principal <client_id> --client-secret <client_secret> --agent-vm-size Standard_DS3_v2 --agent-count 2 --generate-ssh-keys
az acs create --orchestrator-type kubernetes --resource-group %rg% --name %k8sname% --service-principal %serviceprincipal% --client-secret %clientsecret% --agent-vm-size Standard_DS3_v2 --agent-count 2 --ssh-key-value %userprofile%\.ssh\id_rsa.pub

@REM Must for first time only ; Install Kubectl CLI. If you are using Windows than kubectl is in program files (x86). Make sure it is in your PATH variable
az acs kubernetes install-cli

@REM Connect kubectl to cluster
az acs kubernetes get-credentials --resource-group=%rg% --name=%rg%

@REM Proxy to the dashboard
kubectl proxy
