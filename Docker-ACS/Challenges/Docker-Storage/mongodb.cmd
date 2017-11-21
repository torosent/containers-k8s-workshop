@REM Without external storage
docker run --name mongodb -d mongo
docker ps -a 
docker rm mongodb

@REM windows
docker run -d --name mongodb --mount source=MongoDBData,target=/data/db mongo
