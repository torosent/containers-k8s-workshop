#! /bin/sh

# tag image
docker tag helloworld torosent/helloworld:1.0.0

# login to hub
docker login

# push to hub
docker push torosent/helloworld:1.0.0