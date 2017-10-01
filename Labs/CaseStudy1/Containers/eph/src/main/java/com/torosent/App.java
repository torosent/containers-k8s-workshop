
package com.torosent;

import com.microsoft.azure.eventprocessorhost.EventProcessorHost;
import com.microsoft.azure.eventprocessorhost.EventProcessorOptions;
import com.microsoft.azure.servicebus.ConnectionStringBuilder;

import java.util.concurrent.ExecutionException;


public class App {

    static EventProcessorHost host;

    public static void main(String[] args) {



        String namespaceName = System.getenv("NAMESPACE");
        String eventHubName = System.getenv("EH_NAME");
        String sasKeyName = System.getenv("SAS_KEY_NAME");
        String sasKey = System.getenv("SAS_KEY");

        String consumerGroupName = "$Default";
        String storageConnectionString = System.getenv("STORAGE_CONN_STRING");
        String storageContainerName = System.getenv("STORAGE_CONTAINER");

        ConnectionStringBuilder eventHubConnectionString = new ConnectionStringBuilder(namespaceName, eventHubName, sasKeyName, sasKey);
        host = new EventProcessorHost(eventHubName, eventHubConnectionString.getEntityPath(), consumerGroupName, eventHubConnectionString.toString(), storageConnectionString, storageContainerName);
        EventProcessorOptions options = EventProcessorOptions.getDefaultOptions();
        options.setExceptionNotification(new ErrorNotificationHandler());

        try {
            CosmosDBConnector.init();
            host.registerEventProcessor(EventProcessor.class, options).get();
        } catch (Exception e) {
            System.out.print("Failure while registering: ");
            if (e instanceof ExecutionException) {
                Throwable inner = e.getCause();
                System.out.println(inner.toString());
            } else {
                System.out.println(e.toString());
            }
        }
    }

    public void stop() {
        try {
            host.unregisterEventProcessor();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }

}
