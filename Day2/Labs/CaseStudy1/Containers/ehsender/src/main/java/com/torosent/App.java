
package com.torosent;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.eventhubs.EventData;
import com.microsoft.azure.eventhubs.EventHubClient;
import com.microsoft.azure.servicebus.ConnectionStringBuilder;
import com.microsoft.azure.servicebus.ServiceBusException;

import java.io.IOException;


public class App {

    public static void main(String[] args) {

        String namespaceName = System.getenv("NAMESPACE");
        String eventHubName = System.getenv("EH_NAME");
        String sasKeyName = System.getenv("SAS_KEY_NAME");
        String sasKey = System.getenv("SAS_KEY");

        ConnectionStringBuilder eventHubConnectionString = new ConnectionStringBuilder(namespaceName, eventHubName, sasKeyName, sasKey);

        try {
            EventHubClient ehClient = EventHubClient.createFromConnectionStringSync(eventHubConnectionString.toString());


            for (int i = 0; i < 100; i++) {
                String message = "mymessage" + i;

                Message msg = new Message();
                msg.setMessage(message);

                ObjectMapper mapper = new ObjectMapper();
                String jsonInString = mapper.writeValueAsString(msg);
                EventData sendEvent = new EventData(jsonInString.getBytes());
                ehClient.sendSync(sendEvent);
                System.out.println(message);
            }
            ehClient.closeSync();

        } catch (ServiceBusException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
