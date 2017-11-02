#! /bin/sh


# connect to cluster
ssh azureuser@myswarmclu-swarmworkshop-73a4eamgmt.ukwest.cloudapp.azure.com -A -p 2200

# docker service create -p 80:80 --replicas 1 --name myfirstapp torosent/myfirstapp
# docker service inspect --pretty myfirstapp
# docker service scale myfirstapp=5
# docker service ps myfirstapp
# docker service rm myfirstapp