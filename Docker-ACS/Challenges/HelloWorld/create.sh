#! /bin/sh

docker run --name helloworld -p 80:80 tutum/hello-world 
docker ps -a
docker rm helloworld
docker ps -a
docker run --name helloworld --rm -d -p 80:80 tutum/hello-world
docker ps -a

