@REM Without external storage
docker run --name mongodb -d mongo
docker ps -a 
docker rm mongodb

@REM windows
docker run --name mongodb -v /c/MongoDBData:/data/db -d mongo
