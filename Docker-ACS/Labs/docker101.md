# Get Started

``` A few of these excerises are from https://github.com/docker/docker.github.io ```

In the past, if you were to start writing a Python app, your first order of business was to install a Python runtime onto your machine. But, that creates a situation where the environment on your machine has to be just so in order for your app to run as expected; ditto for the server that runs your app.
With Docker, you can just grab a portable Python runtime as an image, no installation necessary. Then, your build can include the base Python image right alongside your app code, ensuring that your app, its dependencies, and the runtime, all travel together.
These portable images are defined by something called a Dockerfile.

## Exercise 1

Checklist
  *	Docker Installed – [Download Here](https://store.docker.com/search?type=edition&offering=community)  

### Define a container with a Dockerfile
Dockerfile will define what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you have to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile will behave exactly the same wherever it runs.

### Dockerfile
Create an empty directory and put this file in it, with the name Dockerfile. Take note of the comments that explain each statement.

```bash
# Use an official Python runtime as a parent image
FROM python:2.7-slim
# Set the working directory to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app
# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt
# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World
# Run app.py when the container launches
CMD ["python", "app.py"]
```

This Dockerfile refers to a couple of things we haven’t created yet, namely app.py and requirements.txt. Let’s get those in place next.
 
### The app itself
Grab these two files and place them in the same folder as Dockerfile. This completes our app, which as you can see is quite simple. When the above Dockerfile is built into an image, app.py and requirements.txt will be present because of that Dockerfile’s ADD command, and the output from app.py will be accessible over HTTP thanks to the EXPOSE command.

#### requirements.txt
>
> Flask
>
> Redis
>

#### app.py

```python
from flask import Flask
from redis import Redis, RedisError
import os
import socket
# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)
app = Flask(__name__)
@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

Now we see that pip install -r requirements.txt installs the Flask and Redis libraries for Python, and the app prints the environment variable NAME, as well as the output of a call to socket.gethostname(). Finally, because Redis isn’t running (as we’ve only installed the Python library, and not Redis itself), we should expect that the attempt to use it here will fail and produce the error message.
Note: Accessing the name of the host when inside a container retrieves the container ID, which is like the process ID for a running executable.

### Build the app
That’s it! You don’t need Python or anything in requirements.txt on your system, nor will building or running this image install them on your system. It doesn’t seem like you’ve really set up an environment with Python and Flask, but you have.
Here’s what ls should show:

```bash
$ ls
Dockerfile		app.py			requirements.txt
```

Now run the build command. This creates a Docker image, which we’re going to tag using -t so it has a friendly name.
```bash
docker build -t myfirstapp .
```

Where is your built image? It’s in your machine’s local Docker image registry:

```bash
$ docker images

REPOSITORY            TAG                 IMAGE ID
myfirstapp         latest              326387cea398
```
 
### Run the app
Run the app, mapping your machine’s port 4000 to the container’s EXPOSEd port 80 using -p:

```bash
docker run -p 4000:80 myfirstapp
```

You should see a notice that Python is serving your app at http://0.0.0.0:80. But that message is coming from inside the container, which doesn’t know you mapped port 80 of that container to 4000, making the correct URL http://localhost:4000.
Go to that URL in a web browser to see the display content served up on a web page, including “Hello World” text, the container ID, and the Redis error message.

### Now with Redis 
```bash
docker run --rm --name some-redis -d redis
docker run --rm --name myfirstapp -p 4000:80 --link some-redis:redis -d myfirstapp
```

## Share your image
To demonstrate the portability of what we just created, let’s upload our built image and run it somewhere else. After all, you’ll need to learn how to push to registries when you want to deploy containers to production.
A registry is a collection of repositories, and a repository is a collection of images—sort of like a GitHub repository, except the code is already built. An account on a registry can create many repositories. The docker CLI uses Docker’s public registry by default.
Note: We’ll be using Docker’s public registry here just because it’s free and pre-configured, but you can use Azure Container Registry, and you can even set up your own private registry using [Docker Trusted Registry](https://docs.docker.com/datacenter/dtr/2.2/guides/).

### Log in with your Docker ID
If you don’t have a Docker account, sign up for one at [hub.docker.com](hub.docker.com). Make note of your username.
Log in to the Docker public registry on your local machine.
```bash
docker login
```

### Tag the image
The notation for associating a local image with a repository on a registry is username/repository:tag. The tag is optional, but recommended, since it is the mechanism that registries use to give Docker images a version. Give the repository and tag meaningful names for the context, such as get-started:part1. This will put the image in the get-started repository and tag it as part1.
Now, put it all together to tag the image. Run docker tag image with your username, repository, and tag names so that the image will upload to your desired destination. The syntax of the command is:

```bash
docker tag image username/repository:tag
```

For example:
```bash
docker tag myfirstapp john/get-started:part1
```

Run [docker images](https://docs.docker.com/engine/reference/commandline/images/) to see your newly tagged image. (You can also use docker image ls.)
```bash
$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
myfirstapp            latest              d9e555c53008        3 minutes ago       195MB
john/get-started         part1               d9e555c53008        3 minutes ago       195MB
python                   2.7-slim            1c7128a655f6        5 days ago          183MB
...
```

### Publish the image
Upload your tagged image to the repository:

```bash
docker push username/repository:tag
```
Once complete, the results of this upload are publicly available. If you log in to [Docker Hub](https://hub.docker.com), you will see the new image there, with its pull command.
 
### Pull and run the image from the remote repository
From now on, you can use docker run and run your app on any machine with this command:

```bash
docker run -p 4000:80 username/repository:tag
```

If the image isn’t available locally on the machine, Docker will pull it from the repository.

```bash
$ docker run -p 4000:80 john/get-started:part1
Unable to find image 'john/get-started:part1' locally
part1: Pulling from orangesnap/get-started
10a267c67f42: Already exists
f68a39a6a5e4: Already exists
9beaffc0cf19: Already exists
3c1fe835fb6b: Already exists
4c9f1fa8fcb8: Already exists
ee7d8f576a14: Already exists
fbccdcced46e: Already exists
Digest: sha256:0601c866aab2adcc6498200efd0f754037e909e5fd42069adeff72d1e2439068
Status: Downloaded newer image for john/get-started:part1
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
```

Note: If you don’t specify the :tag portion of these commands, the tag of :latest will be assumed, both when you build and when you run images. Docker will use the last version of the image that ran without a tag specified (not necessarily the most recent image).
No matter where docker run executes, it pulls your image, along with Python and all the dependencies from requirements.txt, and runs your code. It all travels together in a neat little package, and the host machine doesn’t have to install anything but Docker to run it.

## Exercise 2 - Deploy to Web App on Linux

Checklist
  * AzureCLI installed - [Guide here](C:\JDA\DX\_FY18\LDNContainers\containers-k8s-workshop\Day1\Labs\Guide here)
  * Login with Azure CLI - [Guide Here](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest)
  * Select the correct Azure Subscription, if you have access to multiple - Guide here 
  * Login to Azure CLI using az login. Make sure you set the subscription as well. Tip: Login with Service Principal.

### Create a resource group
The following example creates a resource group named myResourceGroup in the West Europe location.

```bash
az group create --name myResourceGroup --location "West Europe"
```

You generally create your resource group and the resources in a region near you. To see all supported locations for Azure Web Apps, run the `az appservice list-locations` command.

### Create an Azure App Service plan
In the Cloud Shell, create an App Service plan with the `az appservice plan create` command.
An **App Service plan** specifies the location, size, and features of the web server farm that hosts your app. You can save money when hosting multiple apps by configuring the web apps to share a single App Service plan.
App Service plans define:
  * Region (for example: North Europe, East US, or Southeast Asia)
  * Instance size (small, medium, or large)
  * Scale count (1 to 20 instances)
  * SKU (Free, Shared, Basic, Standard, or Premium)
The following example creates an App Service plan named `myAppServicePlan` in the Standard pricing tier and in a Linux container:
```bash
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku S1 --is-linux
```

When the App Service plan has been created, the Azure CLI shows information similar to the following example:
```json
{ 
  "adminSiteName": null,
  "appServicePlanName": "myAppServicePlan",
  "geoRegion": "West Europe",
  "hostingEnvironmentProfile": null,
  "id": "/subscriptions/0000-0000/resourceGroups/myResourceGroup/providers/Microsoft.Web/serverfarms/myAppServicePlan",
  "kind": "app",
  "location": "West Europe",
  "maximumNumberOfWorkers": 1,
  "name": "myAppServicePlan",
  < JSON data removed for brevity. >
  "targetWorkerSizeId": 0,
  "type": "Microsoft.Web/serverfarms",
  "workerTierName": null
}
```

### Create a web app
Create a **web app** in the `myAppServicePlan` App Service plan with the `az webapp create` command. Don't forget to replace `<app name>` with a unique app name.

```bash
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name <app name> --deployment-container-image-name elnably/dockerimagetest
```
In the preceding command, `--deployment-container-image-name` points to the public Docker Hub image [https://hub.docker.com/r/elnably/dockerimagetest/](https://hub.docker.com/r/elnably/dockerimagetest/). You can inspect its content at [https://github.com/rachelappel/docker-image](https://github.com/rachelappel/docker-image).
When the web app has been created, the Azure CLI shows output similar to the following example:
```bash
{
  "availabilityState": "Normal",
  "clientAffinityEnabled": true,
  "clientCertEnabled": false,
  "cloningInfo": null,
  "containerSize": 0,
  "dailyMemoryTimeQuota": 0,
  "defaultHostName": "<app name>.azurewebsites.net",
  "deploymentLocalGitUrl": "https://<username>@<app name>.scm.azurewebsites.net/<app name>.git",
  "enabled": true
}
```

### Browse to the app
Browse to the following URL using your web browser.
http://`<app_name>`.azurewebsites.net


### Clean up the resources 

```bash
az group delete -n myResourceGroup -y --no-wait
```

## Exercise 3 – Coding with containers

Checklist
  * Node & npm installed - [Download here](https://nodejs.org/en/) 
  * VSCode - [Download here](https://code.visualstudio.com/) 
  * [On Windows] Use Powershell to execute commands
  * [Optional] Docker extension for VSCode - [Install here](https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker) 

In this exercise, we’ll build out a golang backend and nodejs frontend. 

We’ll build and run the golang backend easily using the golang container then we’ll debug an issue in nodejs by attaching our debugger to the running container. 

### Build and Run the Backend
At a terminal navigate to the directory for the backend

```bash
cd [location of labs git here]/Docker-ACS/Labs/Exercise3/backend/
```
Let’s look at our backend code using vscode, run the following

```
code .
```

If you’ve written golang before, or even if you haven’t, it should hopefully be easy to tell roughly what the ‘server.go’ file will do. It will respond to requests on ‘/bar’ with “Hello /bar”

Golang has a relatively complex [install and setup procedure](https://golang.org/doc/install) and requires code to be at a certain path to be built. 

To make this easier we’ll use a docker containers the tools to build and run the code. This pattern can be used to simplify setup and build while also providing local “CI” like functionality for complex projects. 

Run the following to launch a container with the golang tooling and mount the current directory into the container.

>In the command below we use $(pwd) to insert the current working directory into the volume mount command. It’s the same as manually doing ‘-v /current/directory/here:/go/src/test/backend’. Plus, make sure not to use Git Bash.

```bash
docker run -ti --rm -v $(pwd):/go/src/test/backend golang
```
> On windows, when in Command Prompt, use the `%cd%` to get your current directory. The bash command should work as expected under powershell. 

Command Prompt:
```bash
docker run -ti --rm -v %cd%:/go/src/test/backend golang
``` 

Now let’s do a build

```bash
cd src/test/backend/
go build .
```


The build tooling will have worked but you’ll notice in the output that there is a bug we have to fix. 

```bash
root@ce58744b24f3:/go/src/backend# go build .
# command-line-arguments
runtime.main_main·f: relocation target main.main not defined
runtime.main_main·f: undefined: "main.main"
```

We’ve got a typo in our golang file. Switch back to VSCode and in ‘server.go’ change the function name ‘shouldbemain’ to ‘main’ and save the file. 

As the directory is mounted into our container we can now simple rerun the build command to see if our fix worked. Let’s rebuild and run the backend:

```bash
go build .
./backend
```

With the server is up and running you should see:

```bash
root@ce58744b24f3:/go/src/backend# go build .
root@ce58744b24f3:/go/src/backend# ./backend
Hooking up hanlders...
Running server...
```

How we’ve fixed the bug let’s use the dockerfile*  to build a docker image and use this to run the backend. Use ‘ctrl-c’ and then ‘exit’ to leave golang tools container. Now build the docker file:

> *This file uses the golang container to build our application then copies the binary into a new container, which doesn’t contain all the golang build tools. This keeps the container image nice and small for speedy deployments. 

```bash
docker build . -t gobackend
docker run -d -p 8181:80 gobackend
```

Open a browser and test the service by hitting [http://localhost:8181/bar](http://localhost:8181/bar) you should see ‘hello, /bar”

### Build and Debug the Frontend (Adapted from [Docker-tools lab](https://github.com/docker/labs/blob/master/developer-tools/nodejs-debugging/VSCode-README.md))

Now let’s get the frontend setup, surprise surprise we’ll run this in a container. In the frontend, let’s pretend there a more complex bug which we’ll need to debug through VSCode. 

Open the directory and start VSCode

```bash
cd [location of labs git repo]/Docker-ACS/Labs/Exercise3/frontend/
code .
```
We’ve got a fairly simple nodejs app, you can have a look at ‘app.js’ but don’t worry too much for now. 

Let’s focus on the ‘.vscode’ directory. This has a ‘task.json’ and ‘launch.json’ which will let us build and then debug our node app inside the same container it will use when deployed. This is great to get those hard to find bugs related to environment setup and avoid the “Works here but not when deployed” nightmare. 

Let’s try it. 

1.	CTRL+Shift+B (Windows) or CMD+Shift+B (Mac) to build and start your container
2.	Wait for that to complete
3.	Press F5 to start debugging
4.  Browse the site at [http://localhost:8182](http://localhost:8182)
5.	Open ‘app.js’ and set a breakpoint on Line 5 
6.	Change some of the words in the string on Line 8 and save the file
7.	See how the breakpoint is hit!

#### How did that work?

In the dockerfile, as with python earlier, we install our dependencies and copy in our code. 

```bash
FROM node:8.2.1-alpine

WORKDIR /code

RUN npm install -g nodemon@1.11.0

COPY package.json /code/package.json
RUN npm install && npm ls
RUN mv /code/node_modules /node_modules

COPY . /code

CMD ["npm", "start"]
```

We use the ‘nodemon’ tool which will run our node app and restart it each time one of the source files changes. We’ll use the same trick as we in our golang example to mount our current directory so edits in VSCode affect the container. 

By default, our container doesn’t run using nodemon as you wouldn’t want this in production, instead the ‘CMD’ statement uses npm to launch the app normally. We’re going to override this behavior by passing a command when we call ‘docker run’.

To make this easier to use we’ve setup these commands as build tasks in VSCode. If you look at ‘.vscode/tasks.json’ you will see the following: 

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "taskName": "Build Container",
            "type": "shell",
            "command": "docker build . -t debugimage"
        },
(...)
```

```json
(...)
        {
            "taskName": "Run Container",
            "type": "shell",            
            "command": "docker run --rm -v ${workspaceRoot}:/code -p 8182:8000 -p 9339:9339 --name debuginstance debugimage nodemon --inspect-brk=0.0.0.0:9339",
            "isBackground": true,
            "promptOnClose": true,
            "dependsOn": [
                "Build Container"
            ]
        }
  ]
}}
```

> In the command `${workspaceRoot}` inserts the directory you currently have open in VSCode, `[lab git location]/Docker-ACS/Labs/Exercise3/frontend/`. This replaces `${PWD}` or `%CD%`, which we used earlier in the exercise. You can see the other variables available to you in VSCode task files [here](https://code.visualstudio.com/docs/editor/tasks#_variable-substitution)

This file defines our default build task, so you can press CTRL+Shift+B (Windows) or CMD+Shift+B (Mac) to build and start your container. Try this now and see what happens. 

The first section builds the container from the docker file. 

The second section runs the docker container in the background, the arguments do as follows:
1.	‘-v’ mounts the current directory into the container so code changes in VSCode are available in the container
2.	‘-p’ to exposing the port for the web app and the debugger. 
3.	‘debugcontainer’ specifies the image name to use
4.	‘nodemon –--inspect-brk=9229’  will get executed inside the container when it starts. It starts nodemon and the debugger. 

Now let’s take a look at ‘.vscode/launch.json’ this file defines how VSCode debugs your application. 

```json
   {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Docker: Attach to Node",
                "type": "node",
                "request": "attach",
                "port": 9339,
                "address": "localhost",
                "localRoot": "${workspaceRoot}",
                "remoteRoot": "/code",
                "restart": true,
                "sourceMaps": false        
           }
        ]
    }
```

Here, VSCode will use node and it should attach to the debugger on port 9339. Also, VSCode will know where the source files are stored in the container with the `remoteRoot` property. This is crucial, as it allows VSCode to map break points from the editor to the code running in the container. 


