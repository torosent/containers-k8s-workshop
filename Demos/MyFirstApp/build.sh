docker build -t helloworld .
docker run --rm -p 3000:80 helloworld

docker run --name some-redis -d redis
docker run --name helloworld -p 3000:80 --link some-redis:redis -d helloworld
