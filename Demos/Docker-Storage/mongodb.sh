# Without external storage
docker run -v -d mongo

# With external storage
docker run -v /Users/torosent/MongoDBData:/data/db -d mongo