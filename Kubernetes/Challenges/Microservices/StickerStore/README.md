# **Deprecated**
## Refer to [Microservices Challenge](https://github.com/torosent/k8s-workshop-microservices)

## Architecture

![image](https://user-images.githubusercontent.com/17064840/35954452-b18fbdbe-0cc4-11e8-952d-cb5d3aee2341.png)

## Challenge

1. Build the containers [Sample](/Kubernetes/Challenges/Microservices/StickerStore/Deployment/commands.sh)
2. Provision Azure Container Registry (ACR) & Azure Service Bus Queue (Queue name=stickersqueue) [ACR](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli)
3. Setup ACR in the K8S cluster
4. Push the containers into ACR
5. Deploy the microservices application in K8S
