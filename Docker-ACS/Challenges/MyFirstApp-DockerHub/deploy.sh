#! /bin/sh

# tag image
docker tag myfirstapp torosent/myfirstapp:1.0.0

# login to hub
docker login

# push to hub
docker push torosent/myfirstapp:1.0.0
docker push torosent/myfirstapp