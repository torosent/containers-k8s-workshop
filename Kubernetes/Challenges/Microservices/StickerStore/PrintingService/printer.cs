using System;
using Microsoft.Azure.ServiceBus;
using System.Threading.Tasks;
using System.Threading;
using System.Text;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;

    class Printer
    {
        static IQueueClient queueClient;
        static CloudTableClient tablelient;

        public Printer()
        {
            try
            {
                var serviceBusConnectionString = Environment.GetEnvironmentVariable("SBConnectionString");
                Console.WriteLine(serviceBusConnectionString);
                var storageConnectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
                CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(storageConnectionString);
                Console.WriteLine(storageConnectionString);

                tablelient = cloudStorageAccount.CreateCloudTableClient();
                
                Console.WriteLine("Created Table Client");

                const string QueueName = "stickersqueue";
                queueClient = new QueueClient(serviceBusConnectionString, QueueName);
                Console.WriteLine("Created Queue Client");

                RegisterOnMessageHandlerAndReceiveMessages();
                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

        }


        static void RegisterOnMessageHandlerAndReceiveMessages()
        {
            // Configure the MessageHandler Options in terms of exception handling, number of concurrent messages to deliver etc.
            var messageHandlerOptions = new MessageHandlerOptions(ExceptionReceivedHandler)
            {
                // Maximum number of Concurrent calls to the callback `ProcessMessagesAsync`, set to 1 for simplicity.
                // Set it according to how many messages the application wants to process in parallel.
                MaxConcurrentCalls = 1,

                // Indicates whether MessagePump should automatically complete the messages after returning from User Callback.
                // False value below indicates the Complete will be handled by the User Callback as seen in `ProcessMessagesAsync`.
                AutoComplete = false
            };
            // Register the function that will process messages
            queueClient.RegisterMessageHandler(ProcessMessagesAsync, messageHandlerOptions);
            Console.WriteLine("Registered Message Handler");

        }
        static async Task ProcessMessagesAsync(Message message, CancellationToken token)
        {
            var body = Encoding.UTF8.GetString(message.Body);
            // Process the message
            Console.WriteLine($"Received message: SequenceNumber:{message.SystemProperties.SequenceNumber} Body:{body}");

            const string version = "1.0.8";
            body = $"{body} ; Printer version: {version}";

            InsertRowToTableStorage(body);
            Thread.Sleep(500);
            // Complete the message so that it is not received again.
            // This can be done only if the queueClient is opened in ReceiveMode.PeekLock mode (which is default).
            await queueClient.CompleteAsync(message.SystemProperties.LockToken);
        }

        static Task ExceptionReceivedHandler(ExceptionReceivedEventArgs exceptionReceivedEventArgs)
        {
            Console.WriteLine($"Message handler encountered an exception {exceptionReceivedEventArgs.Exception}.");
            return Task.CompletedTask;
        }

        static async void InsertRowToTableStorage(string body)
        {
            var table = tablelient.GetTableReference("status");
            await table.CreateIfNotExistsAsync();

            StatusEntity status = new StatusEntity();
            status.Message = body;

            // Create the TableOperation object that inserts the customer entity.
            TableOperation insertOperation = TableOperation.InsertOrReplace(status);
            // Execute the insert operation.
            await table.ExecuteAsync(insertOperation);
        }
    }
