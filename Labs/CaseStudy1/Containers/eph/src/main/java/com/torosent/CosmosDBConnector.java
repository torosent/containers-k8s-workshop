package com.torosent;

import com.microsoft.azure.documentdb.*;

import java.io.IOException;

public class CosmosDBConnector {

    static DocumentClient client;

    public static void init() throws IOException, DocumentClientException {
        String name = System.getenv("COSMOSDB_NAME");
        String key = System.getenv("COSMOSDB_KEY");
        client = new DocumentClient("https://" + name + ".documents.azure.com",
            key,
            new ConnectionPolicy(),
            ConsistencyLevel.Session);

        createDatabaseIfNotExists("EHDB");
        createDocumentCollectionIfNotExists("EHDB", "EHCollection");
    }

    private static void createDatabaseIfNotExists(String databaseName) throws DocumentClientException, IOException {
        String databaseLink = String.format("/dbs/%s", databaseName);

        // Check to verify a database with the id=FamilyDB does not exist
        try {
            client.readDatabase(databaseLink, null);
            System.out.println(String.format("Found %s", databaseName));
        } catch (DocumentClientException de) {
            // If the database does not exist, create a new database
            if (de.getStatusCode() == 404) {
                Database database = new Database();
                database.setId(databaseName);

                client.createDatabase(database, null);
                System.out.println(String.format("Created %s", databaseName));
            } else {
                throw de;
            }
        }
    }

    private static void createDocumentCollectionIfNotExists(String databaseName, String collectionName) throws IOException,
            DocumentClientException {
        String databaseLink = String.format("/dbs/%s", databaseName);
        String collectionLink = String.format("/dbs/%s/colls/%s", databaseName, collectionName);

        try {
            client.readCollection(collectionLink, null);
            System.out.println(String.format("Found %s", collectionName));
        } catch (DocumentClientException de) {
            // If the document collection does not exist, create a new
            // collection
            if (de.getStatusCode() == 404) {
                DocumentCollection collectionInfo = new DocumentCollection();
                collectionInfo.setId(collectionName);

                // Optionally, you can configure the indexing policy of a
                // collection. Here we configure collections for maximum query
                // flexibility including string range queries.
                RangeIndex index = new RangeIndex(DataType.String);
                index.setPrecision(-1);

                collectionInfo.setIndexingPolicy(new IndexingPolicy(new Index[] {index }));

                // DocumentDB collections can be reserved with throughput
                // specified in request units/second. 1 RU is a normalized
                // request equivalent to the read of a 1KB document. Here we
                // create a collection with 400 RU/s.
                RequestOptions requestOptions = new RequestOptions();
                requestOptions.setOfferThroughput(400);

                client.createCollection(databaseLink, collectionInfo, requestOptions);

                System.out.println(String.format("Created %s", collectionName));
            } else {
                throw de;
            }
        }

    }
    public static void insertDocument(Message msg) throws DocumentClientException {

        try {
            String documentLink = String.format("/dbs/%s/colls/%s/docs/%s", "EHDB", "EHCollection", msg.getId());
            client.readDocument(documentLink, new RequestOptions());
        } catch (DocumentClientException de) {
            if (de.getStatusCode() == 404) {
                String collectionLink = String.format("/dbs/%s/colls/%s", "EHDB", "EHCollection");
                client.createDocument(collectionLink, msg, new RequestOptions(), true);
                System.out.println(String.format("Created Message %s", msg.getId()));
            } else {
                throw de;
            }
        }


    }
}
