docker build -t myfirstapp .
docker run --name myfirstapp --rm -p 3000:80 myfirstapp
docker ps -a
docker run --name some-redis -d redis
docker run --name myfirstapp -p 3000:80 --link some-redis:redis -d myfirstapp
