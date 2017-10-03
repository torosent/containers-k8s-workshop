using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;

namespace StatusService.Controllers
{
    [Route("api/[controller]")]
    public class StatusController : Controller
    {
        static CloudTableClient tablelient;

        // GET api/values
        [HttpGet]
        public async Task<string> Get()
        {
            CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(Environment.GetEnvironmentVariable("StorageConnectionString"));
            tablelient = cloudStorageAccount.CreateCloudTableClient();
            var table = tablelient.GetTableReference("status");
            await table.CreateIfNotExistsAsync();

            // Create the TableOperation object that inserts the customer entity.
            TableOperation retrieveOperation = TableOperation.Retrieve<StatusEntity>("status","name");
            // Execute the insert operation.
            var result = await table.ExecuteAsync(retrieveOperation);
            if (result.Result != null)
            {
                var entity = (StatusEntity)result.Result;
                return entity.Message;
            }
            return "Not Printing";
        }
    }
}
