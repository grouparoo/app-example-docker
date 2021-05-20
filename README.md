# Grouparoo `app-example-docker`

_An example project for deploying Grouparoo with Docker._

Goal: To create a scalable and flexible Grouparoo deployment that:

- Can be auto-scaled as needed
- Will be automatically deployed when the code changes
- Is a [12-factor app](https://12factor.net/) with all configuration stored in the Environment

This repository contains examples of 2 ways to deploy a Dockerized application: `Docker Compose` and `Kubernetes via AWS EKS`.

## How we got here

1. Create a new Grouparoo project. Learn more @ https://www.grouparoo.com/docs/installation.

```
npm install -g grouparoo
grouparoo init .
```

2. Install the Grouparoo plugins you want, e.g.: `grouparoo install @grouparoo/postgres`. Learn more @ https://www.grouparoo.com/docs/installation/plugins

3. Create the `Dockerfile` per the example in this project. Learn more @ https://www.grouparoo.com/docs/installation/docker and by viewing the `Dockerfile` in this repository.
4. (optional) Create the `docker-compose.yml`

## Running this repo

Assuming you have node.js installed (v12+):

1. `git clone https://github.com/grouparoo/app-example-docker.git`
2. `cd app-example-docker`
3. `npm install`
4. `cp .env.example .env`
5. `npm start`

## Deployment with Docker Compose

Grouparoo can be deployed with Docker Compose to orchestrate everything you need for a Grouparoo cluster. This includes:

- Redis and Postgres services for data storage.
- Separate services for both Grouparoo `web` and `worker` roles, so they can be scaled independently.
- 2 internal networks (frontend and backend) to keep your data isolated.

Learn more by viewing the `docker-compose.yml` file included in this repository.

To try Docker Compose deployment (assuming you already have Docker installed and running):

1. Clone and enter into this repository
2. `docker-compose up`. This will download the needed images and build the local `Dockerfile`
3. Wait for the image to build and eventually visit `http://localhost:3000` to see the Grouparoo UI.

Remember, all environment variables can be changed from their defaults, including database information, PORT, etc. All the environment variables have defaults, but you are expected to customize them.

⚠️ Note: The example `docker-compose.yml` in this repository has no data persistence and also no load balancing between `grouparoo-web` instances. Do not use in production.

## Demo Docker Compose Deployment

You can quickly demo a Docker Compose Grouparoo deployment via:

```
curl -L https://www.grouparoo.com/docker-compose --output docker-compose.yml
docker-compose up
```

## Deployment with Kubernetes

This examples uses AWS EKS as our Kuberntes cluster.

#### Create the Kubernetes cluster

- Visit https://console.aws.amazon.com/eks/home and create a new cluster

  - Make a new IAM role to manage your cluster. There's a builder to create a new EKS role. You'll need `AmazonEKSClusterPolicy` and `AmazonEKSServicePolicy`.
  - Ensure that the cluster has public & private access enabled
  - Wait for your cluster to be created (takes ~10 minutes)

- Once your cluster is ready, we need to add compute nodes too it. Click the "add node group" button.

  - Make a new IAM role to manage your node group. There's a builder to create a new EKS - Nodegroup role. Follow these instructions https://docs.aws.amazon.com/eks/latest/userguide/worker_node_IAM_role.html
  - create and add a new SSH keypair.
  - allow remote access from 'all'

- Configure `kubectl` on your computer to deploy to your new cluster\

  - https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html
  - if you need the AWS CLI https://aws.amazon.com/cli/
  - you'll run a command like `aws eks --region us-east-1 update-kubeconfig --name grouparoo-eks-cluster`

Test that you can connect to your cluster and that there are nodes with `kubectl get nodes --watch`

Recommended: deploy the Kubernetes Web UI as well. https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html / https://github.com/kubernetes/dashboard

- kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc7/aio/deploy/recommended.yaml

#### Creating the Aurora Postgres Database

- Visit https://console.aws.amazon.com/rds and create a new Aurora database with "PostgreSQL compatibility".
  - I've chosen "serverless".
  - Note the master name and password
  - Be sure to add the newly created EKS security group to the cluster so that your docker images can connect (it looks something like `eks-cluster-sg-grouparoo-eks-cluster`)
  - under 'additional options' create an initial database name

When the database is created, note the endpoint, something like `grouparoo-db.cluster-c9ntdcugnmdl.us-east-1.rds.amazonaws.com`. This is the database hostname.
The default Postgres username is `postgres`

#### Creating Redis Cluster

- Visit https://console.aws.amazon.com/elasticache and create a new Redis cluster
  - Choose node sizes that work for you, and ensure that there are replicas.
  - Be sure to add the newly created EKS security group to the cluster so that your docker images can connect (it looks something like `eks-cluster-sg-grouparoo-eks-cluster`)

When the redis cluster is created, note the endpoint, something like `grouparoo-redis.es9zaf.ng.0001.use1.cache.amazonaws.com:6379`. This is the redis hostname.

#### Deploy the Kubernetes Pods

Example Podfiles are in the `/kube` directory in this repository. You can deploy these applications to your cluster with `kubectl`:

- `kubectl apply -f kube/grouparoo-worker.yml`
- `kubectl apply -f kube/grouparoo-web.yml`

⚠️ Note: In this example we will be using the database credentials directly. You will likely want to use [Kubernetes secrets](https://kubernetes.io/docs/concepts/configuration/secret/) to store the database connection strings.

⚠️ Note: These examples use the [`grouparoo/app-example-docker`](https://github.com/grouparoo/app-example-docker) Docker image. You will want to replace this with your own image which contains the plugins and secrets you require.

#### Connecting to the web Application

When you created the EKS cluster, AWS also created an Elastic Load Balancer for your cluster. Navigate to https://console.aws.amazon.com/ec2/v2/home?#LoadBalancers:sort=loadBalancerName to see it. There will be a DNS name, like `xxx-yyy.us-east-1.elb.amazonaws.com` which should be publicly accessible.

⚠️ By default, this load balancer will be using port 80 (un-encrypted). You can upload an SSL certificate and switch the port to 443 for HTTPS, or migrate to the new "NLB" network load balancer product.

## Notes

- This repository is built automatically to the [`grouparoo/app-example-docker`](https://hub.docker.com/repository/docker/grouparoo/app-example-docker) image on Docker Hub
  - The `docker-compose.published.yml` included in this repository is linked to `https://www.grouparoo.com/docker-compose`
  - You can run the `docker-compose.published.yml` included in this repository with:

```
curl -L https://www.grouparoo.com/docker-compose --output docker-compose.yml
docker-compose up
```

---

Visit https://github.com/grouparoo/app-examples to see other Grouparoo Example Projects.
