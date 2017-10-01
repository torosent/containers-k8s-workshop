#! /bin/sh

# Create Service Bus Queue - Only from the Portal. CLI Not supported

# Deploy the workers
kubectl create -f worker.yaml

# Deploy the secret for the Service Bus Credencials (Service Principal)
kubectl create -f secret.yaml

# Deploy the pod autoscale
kubectl create -f podautoscale.yaml

