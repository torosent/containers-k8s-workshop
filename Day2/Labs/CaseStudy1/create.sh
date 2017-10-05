#! /bin/sh

# Create Event Hub with 32 partitions - Only from the Portal. CLI Not supported
# Create CosmosDB - Portal
# Create Storage Account for Event Hub Processor Host Logic - Portal

# Deploy the secret for the Event Hub,Storage for EH and CosmosDB Credentials
kubectl create -f secret.yaml

# Deploy the Event Hub processors
kubectl create -f eph.yaml

# Define autoscale
kubectl autoscale deployment eph --cpu-percent=50 --min=1 --max=10

# Simulate cars with event hub loader from local machine with messages and see them in CosmosDB
docker run --rm -it -e NAMESPACE=<namespace> -e EH_NAME=<eh_name> -e SAS_KEY_NAME=<sas_key_name> -e SAS_KEY <sas_key>  torosent/ehsender