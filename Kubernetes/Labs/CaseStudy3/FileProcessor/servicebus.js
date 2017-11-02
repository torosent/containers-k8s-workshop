var azure = require('azure-sb');
var adls = require("./adls.js");

function checkForMessages(sbService, queueName, callback) {
    sbService.receiveQueueMessage(queueName, {
        isPeekLock: true
    }, function (err, lockedMessage) {
        if (err) {
            if (err == 'No messages to receive') {
                console.log('No messages');
            } else {
                callback(err);
            }
        } else {
            callback(null, lockedMessage);
        }
    });
}

function processMessage(sbService, err, lockedMsg) {
    if (err) {
        console.log('Error on Rx: ', err);
    } else {

        // process file from adls
        adls.processFile(lockedMsg.body);

        sbService.deleteMessage(lockedMsg, function (err2) {
            if (err2) {
                console.log('Failed to delete message: ', err2);
            } else {
                console.log('Deleted message.');
            }
        })
    }
}

module.exports = {
    initSB: function () {
        const connStr = process.env.SB_CONNECTION_STRING;
        const queueName = process.env.QUEUE_NAME;
        if (!connStr) throw new Error('Must provide connection string');

        console.log('Connecting to ' + connStr + ' queue ' + queueName);
        let sbService = azure.createServiceBusService(connStr);
        sbService.createQueueIfNotExists(queueName, function (err) {
            if (err) {
                console.log('Failed to create queue: ', err);
            } else {
                adls.loginToAdls(() => {
                    setInterval(checkForMessages.bind(null, sbService, queueName, processMessage.bind(null, sbService)), 2000);

                });
               
            }
        });
    },
}