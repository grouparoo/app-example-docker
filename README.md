# app-example-docker

Example Grouparoo project for deploying Grouparoo with Docker.

Goal: To create a scalable and flexible Grouparoo deployment that:

- Can be auto-scaled as needed
- Will be automatically deployed when the code changes
- Is a [12-factor app](https://12factor.net/) with all configuration stored in the Environment

## Repository Configuration

1. Create a new Grouparoo project. Learn more @ https://www.grouparoo.com/docs/installation.

```
npm install -g grouparoo
grouparoo init .
```

2. Install the Grouparoo plugins you want, e.g.: `grouparoo install @grouparoo/postgres`. Learn more @ https://www.grouparoo.com/docs/installation/plugins

3. Create the `Dockerfile` per the example in this project. Learn more @ https://www.grouparoo.com/docs/installation/docker
4. (optional) Create the `docker-compose.yml`

## Deployment

Learn more about deploying Grouparoo with Docker & Docker Compose @ https://www.grouparoo.com/docs/deployment/docker

Learn more about deploying Grouparoo with Docker & Kubernetes @ https://www.grouparoo.com/docs/deployment/aws-and-k8s

## Notes

- This repository is built automatically to the [`grouparoo/app-example-docker`](https://hub.docker.com/repository/docker/grouparoo/app-example-docker) image on Docker Hub
  - The `docker-compose.published.yml` included in this repository is linked to `https://www.grouparoo.com/docker-compose`
  - You can run the `docker-compose.published.yml` included in this repository with:

```
curl -L https://www.grouparoo.com/docker-compose --output docker-compose.yml
docker-compose up
```

---

Vist https://github.com/grouparoo/app-examples to see other Grouparoo Example Projects.
