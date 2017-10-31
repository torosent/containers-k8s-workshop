# Day 2 - K8s Labs

## Exercise 1

Create a Kubernetes cluster

 1. Open the setup.sh script in the GettingStarted folder.
 1. Edit the location, resource group name, name & service principal id/password
 1. Run the Script. Note that this script installs the Kubernetes CLI (kubectl) and fetching the credentials to the cluster.
 1. Open the cluster dashboard. Run kubectl proxy . Open the browser at 127.0.0.1:8001

## Exercise 2

Create FriendlyHello

 1. Open the MyFirstApp folder
 1. deployment.yaml – The yaml file is the definition of the MyFirstApp deployment.
 1. service.yaml – The yaml file is the definition of the service that exposes MyFirstApp deployment to the world.
 1. Review and execute

### create the MyFirstApp deployment

```bash
kubectl create -f deployment.yaml
```

### expose the deployment with a service

```bash
kubectl create -f service.yaml
```

### describe the service and the deployment

```bash
kubectl describe service
kubectl describe deployment
```

## Exercise 3

Hello-World with deployment version versions

**Folder:** Day2/Demos/Kubernetes/Hello-World

 1. Create  templateV1 deployment. This deployment includes 2 replicas and nginx container with 1.7.9 tag
 1. Get all pods with app=nginx
 1. Describe a specific pod and check the version.
 1. Apply templateV2.yaml. The nginx version is 1.8.
 1. Get all pods with app=nginx
 1. Describe a specific pod and check the version.
 1. Apply templateV3.yaml. The replica count is updated to 4. 
 1. Verify the replica count Get all pods.

### Create V1 template

```bash
kubectl create -f templateV1.yaml
```

### Show pods

```bash
kubectl get pods -l app=nginx
```

### Describe specific pod

```bash
kubectl describe pod <pod-name>
```

### Update V2 template

```bash
kubectl apply -f templateV2.yaml
```

### Show pods

```bash
kubectl get pods -l app=nginx
```

### Describe specific pod

```bash
kubectl describe pod <pod-name>
```

### Update V2 template

```bash
kubectl apply -f templateV3.yaml
```

### Show pods

```bash
kubectl get pods -l app=nginx
```

## Exercise 4

WordPress with MySQL and Azure Disks

Deploy a WordPress site and a MySQL database. Both applications use PersistentVolumes and PersistentVolumeClaims to store data.

Steps:

 1. Create a PersistentVolume
 1. Create a Secret
 1. Deploy MySQL
 1. Deploy WordPress

### Create a PersistentVolume

```bash
kubectl create -f deployment-storage.yaml
```

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast
provisioner: kubernetes.io/azure-disk
parameters:
  skuName: Premium_LRS
  location: northeurope
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
  annotations: 
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 32Gi
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: wp-pv-claim
  labels:
    app: wordpress
  annotations: 
    volume.beta.kubernetes.io/storage-class: fast
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 32Gi
```

Run the following command to verify that two 32GiB PersistentVolumes are available:

```bash
kubectl get pv
```

### Create a MySQL secret

```bash
kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD
```

Verify that the Secret exists by running the following command:

```bash
kubectl get secrets
```

### Deploy MySQL

The following manifest describes a single-instance MySQL Deployment. The MySQL container mounts the PersistentVolume at /var/lib/mysql. The MYSQL_ROOT_PASSWORD environment variable sets the database password from the Secret.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim	
```

Deploy MySQL from the mysql-deployment.yaml file:

```bash
kubectl create -f mysql-deployment.yaml
```

Verify that the Pod is running by running the following command:

```bash
kubectl get pods
```

### Deploy WordPress

The following manifest describes a single-instance WordPress Deployment and Service. It uses many of the same features like a PVC for persistent storage and a Secret for the password. But it also uses a different setting: type: NodePort. This setting exposes WordPress to traffic from outside of the cluster.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  ports:
    - port: 80
  selector:
    app: wordpress
    tier: frontend
  type: LoadBalancer
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: frontend
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
      - image: wordpress:4.8-apache
        name: wordpress
        env:
        - name: WORDPRESS_DB_HOST
          value: wordpress-mysql
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 80
          name: wordpress
        volumeMounts:
        - name: wordpress-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: wordpress-persistent-storage
        persistentVolumeClaim:
          claimName: wp-pv-claim
```

Create a WordPress Service and Deployment from the wordpress-deployment.yaml file:

```bash
kubectl create -f wordpress-deployment.yaml
```

Verify that the Service is running by running the following command:

```bash
kubectl get services wordpress
```
