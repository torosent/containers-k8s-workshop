#! /bin/sh

# Create Service Bus Queue - Only from the Portal. CLI Not supported

# Deploy the secret for the Service Bus Credencials (Service Principal)
kubectl create -f secret.yaml

# Deploy the workers
kubectl create -f fileprocessors.yaml

# Deploy the pod autoscale
kubectl create -f podautoscale.yaml

# Run Messageloader locally
docker run -it --rm -e SB_CONNECTION_STRING=<sbconnection> -e QUEUE_NAME=<queuename> torosent/messagesender
