var msRestAzure = require('ms-rest-azure');
var adlsManagement = require("azure-arm-datalake-store");
var util = require('util');

const adlsAccountName = process.env.ADLS_ACCOUNT_NAME
const clientid = process.env.AZURE_CLIENT_ID
const clientsecret = process.env.AZURE_CLIENT_SECRET
const tenantid = process.env.AZURE_TENANT_ID
const subscriptionid = process.env.AZURE_SUBSCRIPTION_ID


let filesystemClient = {}

module.exports = {
    loginToAdls: function (cb) {
        msRestAzure.loginWithServicePrincipalSecret(clientid, clientsecret, tenantid, function (err, credentials) {
            var acccountClient = new adlsManagement.DataLakeStoreAccountClient(credentials, subscriptionid);
            filesystemClient = new adlsManagement.DataLakeStoreFileSystemClient(credentials);
            cb();


        });
    },
    processFile: function (filename) {
        var pathToEnumerate = '/data/' + filename;
        console.log("Downloading " +pathToEnumerate);
        filesystemClient.fileSystem.open(adlsAccountName, pathToEnumerate, null, function (err, result, request, response) {
            if (err) console.log(err);
            let string ="";
            response.setEncoding('utf8');
            response.on('data', function (response) {
                string += response;

            });
            response.on('end', function () {
                console.log(string);
            });
        })
    }
}