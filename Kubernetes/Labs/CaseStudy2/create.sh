#! /bin/sh

# Create Event Hub with 32 partitions - Only from the Portal. CLI Not supported
# Create CosmosDB - Portal
# Create Storage Account for Event Hub Processor Host Logic - Portal

# Deploy the secret for the Event Hub,Storage for EH and CosmosDB Credentials
kubectl create -f secret.yaml

# Deploy the Event Hub processors
kubectl create -f eph.yaml

# Define autoscale
kubectl autoscale deployment eph --cpu-percent=30 --min=1 --max=32

# Simulate cars with event hub loader with messages and see them in CosmosDB
kubectl create -f ehsender.yaml

# Get deployment metrics
kubectl get hpa

