@REM get Swarm master ip
az network public-ip list --resource-group %rg% --query "[?contains(name,'swarmm-master')].[ipAddress]" -o tsv

@REM connect to cluster
ssh azureuser@$ip -A -p 2200
putty.exe -ssh -i %userprofile%\.ssh\id_rsa.ppk -A -L 8080:localhost:80 azureuser@ip

@REM docker service create -p 80:80 --replicas 1 --name myfirstapp torosent/myfirstapp
@REM docker service inspect --pretty myfirstapp
@REM docker service scale myfirstapp=5
@REM docker service ps myfirstapp
@REM docker service rm myfirstapp