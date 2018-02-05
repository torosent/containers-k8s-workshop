# Without external storage
docker run --name mongodb -d mongo
docker ps -a 
docker stop mongodb
docker rm mongodb

# With external storage
docker run --name mongodb -v /Users/torosent/MongoDBData:/data/db -d mongo
