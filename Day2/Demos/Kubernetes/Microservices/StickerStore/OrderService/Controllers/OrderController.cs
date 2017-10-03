using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.ServiceBus;

namespace OrderService.Controllers
{
    [Route("api/[controller]")]
    public class OrderController : Controller
    {

        static IQueueClient queueClient;

        // POST api/order
        [HttpPost]
        public async void Post(string value, int count)
        {
            var serviceBusConnectionString = Environment.GetEnvironmentVariable("SBConnectionString");
            const string QueueName = "stickersqueue";
            queueClient = new QueueClient(serviceBusConnectionString, QueueName);

            for (var i = 1; i < count+1; i++)
            {
                try
                {
                    // Create a new message to send to the queue
                    string messageBody = $"Printing {value} #{i} ";
                    var message = new Message(Encoding.UTF8.GetBytes(messageBody));

                    // Send the message to the queue
                    await queueClient.SendAsync(message);
                }
                catch (Exception exception)
                {
                    Console.WriteLine($"{DateTime.Now} :: Exception: {exception.Message}");
                }
            }
        }
    }
}
