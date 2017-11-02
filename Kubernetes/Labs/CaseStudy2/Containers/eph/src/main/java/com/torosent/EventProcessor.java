package com.torosent;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.microsoft.azure.eventhubs.EventData;
import com.microsoft.azure.eventprocessorhost.CloseReason;
import com.microsoft.azure.eventprocessorhost.IEventProcessor;
import com.microsoft.azure.eventprocessorhost.PartitionContext;

public class EventProcessor implements IEventProcessor
{
    public void onOpen(PartitionContext context) throws Exception
    {
        System.out.println("Partition " + context.getPartitionId() + " is opening");
    }

    public void onClose(PartitionContext context, CloseReason reason) throws Exception
    {
        System.out.println("Partition " + context.getPartitionId() + " is closing for reason " + reason.toString());
    }

    public void onError(PartitionContext context, Throwable error)
    {
        System.out.println("Partition " + context.getPartitionId() + " got error " + error.toString());
    }

    public void onEvents(PartitionContext context, Iterable<EventData> events) throws Exception
    {
        System.out.println("Partition " + context.getPartitionId() + " got message batch");
        for (EventData data : events)
        {
            try {
                String messagejson = new String(data.getBytes());
                ObjectMapper mapper = new ObjectMapper();
                Message message = mapper.readValue(messagejson, Message.class);
                com.torosent.CosmosDBConnector.insertDocument(message);
            }
            catch (Exception e) // Replace with specific exceptions to catch.
            {
                System.out.println("Error message " + e.getMessage());
                // Handle the message-specific issue, or at least swallow the exception so the
                // loop can go on to process the next event. Throwing out of onEvents results in
                // skipping the entire rest of the batch.
            }

            context.checkpoint(data);
        }
    }

}