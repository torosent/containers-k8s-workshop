# K8S, Jenkins and Microservices deployment

The purpose of this lab is to build and deploy a microservices application to a Kubernetes cluster

In this lab we will:

 1. Install a Jenkins VM with Docker and Kubernetes plugin

 1. Build the images from GitHub repo.

 1. Push the images to Docker Hub.

 1. Execute YAML deployment files in the K8S cluster from the Jenkins pipeline.

## Installation

- Workshop repo:

    ```bash
    git clone https://github.com/torosent/containers-k8s-workshop.git
    ```

- Microservices repo:

    ```bash
    git clone https://github.com/torosent/k8s-workshop-microservices.git
    ```

- Folder: Labs/CaseStudy1

- Fill the values and deploy to K8S the secret.yaml file from the YAML folder.
- Now we will create a VM with Jenkins and Docker.

- Open create.sh or create.cmd and modify the variables with your parameters.

## Create resource group

    ```bash
    az group create -n $rg -l $location

    [Windows]
    az group create --name %rg% --location %location%
    ```

## Create a VM

    ```bash
    az vm create -n $vmname -g $rg --image UbuntuLTS --size $size --admin-username $user --ssh-key-value $ssh --public-ip-address-allocation static --nsg-rule SSH

    [Windows]
    az vm create -n %vmname% -g %rg% --image UbuntuLTS --size %size% --admin-username %user% --ssh-key-value %ssh% --public-ip-address-allocation static --nsg-rule SSH
    ```

## Invoke Jenkins and Docker installation script

    ```bash
    az vm extension set --resource-group $rg --vm-name $vmname --name customScript --publisher Microsoft.Azure.Extensions --settings ./jenkins-config.json

    [Windows]
    az vm extension set --resource-group %rg% --vm-name %vmname% --name customScript --publisher Microsoft.Azure.Extensions --settings .\jenkins-config.json
    ```

## Restart the VM

    ```bash
    az vm restart -n $vmname -g $rg

    [Windows]
    az vm restart -n %vmname% -g %rg%
    ```

## SSH or Putty to the VM

```bash
ssh -L 127. sudo cat /var/lib/jenkins/secrets/initialAdminPassword0.0.1:8080:localhost:8080 azureuser@<ip>

[Windows]
putty.exe -ssh -i %userprofile%\.ssh\id_rsa.ppk -L 8080:localhost:8080 %user%@<ip>
```

## Get the Jenkins initial password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- Open localhost:8080 on your browser
- Install the the suggested plugins

 ![](/images/cs1-jenkins-customize.png)

- Set an initial user
- Go to Manage-Jenkins->Manage-Plugins -> Available Tab
- Install “Azure Container Service” and “Cloudbees Docker Build and Publish” plugins.
- After Jenkins is restarted, create a new “Freestyle Project”

 ![](/images/cs1-jenkins-new-freestyle-project.png)

- Fill in the GitHub URL (https://github.com/torosent/k8s-workshop-microservices) in the GitHub project tab - - and the git URL(https://github.com/torosent/k8s-workshop-microservices.git) in the “Source Code Management”

 ![](/images/cs1-jenkins-source-code-management.png)

- Create a build step “Docker Build and Publish”
- Enter the repo name and tag

 ![](/images/cs1-jenkins-docker-build-and-push.png)

- Add your Docker Hub credentials by clicking on “Add” in “Registry Credentials” 

 ![](/images/cs1-jenkins-registry-credentials.png)

- Modify the “Build Context” in the “Advanced” section to the relevant service folder.
- Modify the “Dockerfile path” in the “Advanced” section to the relevant service folder dockerfile. For example: “Webstore/Dockerfile”

 ![](/images/cs1-jenkins-advanced-configuration.png)

- Add more “Build steps” for each service. You can test is by clicking “Build Now” and checking the Jenkins console for the result.

## Deploy to K8S

- Add “Build step” - > “Azure Container Service”

 ![](/images/cs1-jenkins-acs.png)

- Add “Azure Credentials” (Service Principal)

 ![](/images/cs1-jenkins-service-principal.png)

- Select your K8S container service.
- Add your K8S SSH private key

 ![](/images/cs1-jenkins-ssh-private-key.png)

- Define the service YAML file. You can include multiple YAML files in the “Config Files” section

 ![](/images/cs1-jenkins-deployment-configuration.png)

- Check the K8S cluster
