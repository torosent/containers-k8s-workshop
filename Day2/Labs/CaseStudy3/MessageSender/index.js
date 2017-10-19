var azure = require('azure-sb');


const connStr = process.env.SB_CONNECTION_STRING;
const queueName = process.env.QUEUE_NAME;
if (!connStr) throw new Error('Must provide connection string');

console.log('Connecting to ' + connStr + ' queue ' + queueName);
let sbService = azure.createServiceBusService(connStr);
sbService.createQueueIfNotExists(queueName, function (err) {
    if (err) {
        console.log('Failed to create queue: ', err);
    } else {
            var message = {
                body: 'test.txt'
            };
           
            setInterval(sendMessage.bind(null, sbService,message ), 10);
    }
});

function sendMessage(sbService,message)
{
    sbService.sendQueueMessage(queueName, message, function (error) {
        if (error) {
            console.log(error);
        }
        else
        {
            console.log('Message Sent');
        }

    });
}