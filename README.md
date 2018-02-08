# Containers & K8S Workshop

## Docker, DC/OS and Swarm

### Challenges

1. Hello-World - hello world app on local machine.
2. MyFirstApp - Dockerfile & docker build demos. - Reference `https://docs.docker.com/get-started/part2/`
3. MyFirstApp-DockerHub - push MyFirstApp to DockerHub and pull the image back.
4. Docker-Storage - MongoDB container with persistent storage.
5. Docker-Compose - Wordpress with MySQL deployment. - Reference `https://docs.docker.com/compose/wordpress/`
6. DC/OS - Deployment.
7. Swarm - Deployment.
8. ACI - Azure Container Instances demo.

### Labs

docker101.md - Create MyFirstApp container and deploy to Azure Web App on Linux.

## Kubernetes

### Challenges

1. Hello-World - deployment with versions. - `https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/`
2. MyFirstApp - deployment
3. Secrets-Configmaps - deploy pods with config maps
4. Persistent-Storage - deploy Wordpress, MySQL with external storage - `https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/`
3. Helm - Deploy Joomla Helm chart
5. DataDog Monitoring - Deploy datadog helm chart and montior the cluster.
6. Jenkins - Install Jenkins helm chart
7. Jenkins-Pipeline - Create StickerStore CI/CD Pipeline.  [Instructions](https://github.com/torosent/containers-k8s-workshop/tree/master/Kubernetes/Challenges/Jenkins-Pipeline)
8. Microservices - StickerStore Microservices application [Instructions](https://github.com/torosent/k8s-workshop-microservices)


### Labs

1. CaseStudy 1 - Auto scale an app
2. CaseStudy 2 - Data, Using Event Hub Processing Host In K8s

## Setup SSH port forwarding examples

### If you are using Windows:
Install Putty or use any bash shell for Windows (if using a bash shell, follow the instructions for Linux or Mac).

Run this command:
```
putty.exe -ssh -i <path to private key file> -L 8080:localhost:8080 <User name>@<Public DNS name of instance you just created>
```

Or follow these manual steps:
1. Launch Putty and navigate to 'Connection > SSH > Tunnels'
1. In the Options controlling SSH port forwarding window, enter 8080 for Source port. Then enter 127.0.0.1:8080 for the Destination. Click Add.
1. Repeat this process for port 8080.
1. Navigate to 'Connection > SSH > Auth' and enter your private key file for authentication. For more information on using ssh keys with Putty, see [here](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-linux-ssh-from-windows#create-a-private-key-for-putty).
1. Click Open to establish the connection.

### If you are using Linux or Mac:
Run this command:
```bash
ssh -i <path to private key file> -L 8080:localhost:8080 <User name>@<Public DNS name of instance you just created>
```
