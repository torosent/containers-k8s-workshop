#! /bin/sh

# A ConfigMap contains a set of named strings.
kubectl create -f configmap.yaml

# View the values of the keys with kubectl get:
kubectl get configmaps test-configmap -o yaml

# Use the env-pod.yaml file to create a Pod that consumes the ConfigMap in environment variables.
kubectl create -f env-pod.yaml

# This pod runs the env command to display the environment of the container:
kubectl logs config-env-test-pod

# Use the command-pod.yaml file to create a Pod with a container whose command is injected with the keys of a ConfigMap
kubectl create -f command-pod.yaml

# This pod runs an echo command to display the keys:
kubectl logs config-cmd-test-pod

# Use the volume-pod.yaml file to create a Pod that consume the ConfigMap in a volume.
kubectl create -f docs/user-guide/configmap/volume-pod.yaml

# This pod runs a cat command to print the value of one of the keys in the volume:
kubectl logs config-volume-test-pod
