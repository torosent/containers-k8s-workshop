# K8S, Jenkins and StickerStore app deployment

## The purpose of this challenge is to build and deploy a application to a Kubernetes cluster

In this challenge we will:
1.	Install a Jenkins from Helm Chart
2.	Build the images from GitHub repo.
3.	Push the images to Docker Hub.
4.	Execute YAML deployment files in the K8S cluster from the Jenkins pipeline.

 
## Installation

### CI Setup

* fork git repo `https://github.com/torosent/stickerstore.git`

* Create a new "Freestyle Project"

![image](https://user-images.githubusercontent.com/17064840/35767676-869f2014-08f9-11e8-8698-1a18be05a7ba.png)

* Fill in the GitHub URL (https://github.com/<your-username>/stickerstore) in the GitHub project tab and the git URL(https://github.com/torosent/stickerstore.git) in the "Source Code Management"

![image](https://user-images.githubusercontent.com/17064840/35767689-a73909ac-08f9-11e8-8064-3d75ef21233e.png)

* Create a build step "Docker Build and Publish"
* Enter the repo name and tag

![image](https://user-images.githubusercontent.com/17064840/35767691-b95dd2fc-08f9-11e8-9d38-d8cf2b96798b.png)


* Add your Docker Hub credentials by clicking on "Add" in "Registry Credentials 


![image](https://user-images.githubusercontent.com/17064840/35767696-cdfc3122-08f9-11e8-92cd-b4ab28105198.png)

 
*	Modify the "Build Context" in the "Advanced" section to the relevant service folder.
*	Modify the "Dockerfile path" in the "Advanced" section to the relevant service folder dockerfile. For example: "Dockerfile"

![image](https://user-images.githubusercontent.com/17064840/35767710-1c0d3de8-08fa-11e8-9ef5-2364f3b4e070.png)

*	Add more "Build steps" for each service. You can test is by clicking "Build Now" and checking the Jenkins console for the result.
 
### Deploy to K8S

*	Add "Build step" - > "Azure Container Service"

![image](https://user-images.githubusercontent.com/17064840/35767735-80a500ce-08fa-11e8-910d-e55ef0c5363e.png)
 

*	Add "Azure Credentials" (Service Principal)

![image](https://user-images.githubusercontent.com/17064840/35767747-9c98aeb6-08fa-11e8-96a1-86c67fd4be53.png)
 
*	Select your K8S container service.
*	Add your K8S SSH private key

![image](https://user-images.githubusercontent.com/17064840/35767754-b2c451ae-08fa-11e8-942d-6ff69c4a157f.png)

*	Define the service YAML file. You can include multiple YAML files in the "Config Files" section

![image](https://user-images.githubusercontent.com/17064840/35767758-bf999cd6-08fa-11e8-9992-865e551b04b5.png)
 
*	Check the K8S cluster
