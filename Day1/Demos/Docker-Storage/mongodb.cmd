@REM Without external storage
docker run --name mongodb -d mongo
docker ps -a 
docker rm mongodb

@REM With external storage
docker run --name mongodb -v /Users/torosent/MongoDBData:/data/db -d mongo

@REM windows
docker run --name mongodb -v /c/MongoDBData:/data/db -d mongo
