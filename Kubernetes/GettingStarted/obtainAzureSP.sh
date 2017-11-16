#!/bin/bash
# Interactively create an Azure Service Principal for any of your subscriptions
# Author: Bruno Medina (@brusmx)
# Requirements:
# - Azure Cli 2.0
# - jq-1.5
#
# Example of usage: 
# ./obtainSP.sh
ROLE="Contributor"
DEFAULT_ACCOUNT=`az account show`
DEFAULT_ACCOUNT_ID=`echo $DEFAULT_ACCOUNT | jq -r '.id'`
if [ ! -z "$DEFAULT_ACCOUNT_ID" ]; then
    DEFAULT_ACCOUNT_NAME=`echo $DEFAULT_ACCOUNT | jq -r '.name'`
    echo "Current subscription (default): \"${DEFAULT_ACCOUNT_NAME}\" (${DEFAULT_ACCOUNT_ID})"
    ACCOUNT_LIST=`az account list`
    account_id_arr=( `echo $ACCOUNT_LIST |  jq -r '.[].id'`)
    ACCOUNT_LIST_SIZE=`echo $ACCOUNT_LIST |  jq -r '. | length'`
    echo "Found $ACCOUNT_LIST_SIZE enabled subscription(s) in your Azure Account"
    for i in "${!account_id_arr[@]}"
    do
        ACCOUNT_ID=`echo $ACCOUNT_LIST |  jq -r '.['${i}'].name'`
        echo "${i}) ${account_id_arr[$i]} - ${ACCOUNT_ID} "
    done
    echo "Select a subscription (0-`expr ${ACCOUNT_LIST_SIZE} - 1`) or press [enter] to continue with the (default) one:"
    read selection
    if [ -z "$selection" ]; then
        export AZURE_SUBSCRIPTION_ID=$DEFAULT_ACCOUNT_ID
    elif [ "$selection" -gt 0 ] && [ "$selection" -lt "${ACCOUNT_LIST_SIZE}" ]; then
        export AZURE_SUBSCRIPTION_ID=${account_id_arr[$selection]}
    else
        echo "Incorrect selection, Service Principal not created"
        exit 1
    fi
        echo "Selected ${AZURE_SUBSCRIPTION_ID}"
        SP_JSON=`az ad sp create-for-rbac --role="${ROLE}" --scopes="/subscriptions/${AZURE_SUBSCRIPTION_ID}"`

        if [ -z "$SP_JSON" ]; then
            echo "Service Principal not created. Are you sure you are an owner of this subscription?"
            exit 1
        fi
        export AZURE_CLIENT_ID=`echo $SP_JSON | jq -r '.appId'`
        export AZURE_CLIENT_NAME=`echo $SP_JSON | jq -r '.name'`
        export AZURE_CLIENT_SECRET=`echo $SP_JSON | jq -r '.password'`
        export AZURE_TENANT_ID=`echo $SP_JSON | jq -r '.tenant'`
        echo ""
        echo "Now, you can login using your SP by typing the following command:"
        echo "az login --service-principal -u ${AZURE_CLIENT_NAME} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}"
        echo ""
        echo "Also, you can export these as environment variables:"
        echo "export AZURE_CLIENT_ID=${AZURE_CLIENT_ID}"
        echo "export AZURE_CLIENT_NAME=${AZURE_CLIENT_NAME}"
        echo "export AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}"
        echo "export AZURE_TENANT_ID=${AZURE_TENANT_ID}"
else
    echo "Your subscription couldn't be found, make sure you have logged in."
    exit 1
fi
