#!/bin/bash

docker build -t $(DOCKER_USERNAME)/multi-client-k8s:latest -t $(DOCKER_USERNAME)/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t $(DOCKER_USERNAME)/multi-server-k8s-pgfix:latest -t $(DOCKER_USERNAME)/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t $(DOCKER_USERNAME)/multi-worker-k8s:latest -t $(DOCKER_USERNAME)/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

docker push $(DOCKER_USERNAME)/multi-client-k8s:latest
docker push $(DOCKER_USERNAME)/multi-server-k8s-pgfix:latest
docker push $(DOCKER_USERNAME)/multi-worker-k8s:latest

docker push $(DOCKER_USERNAME)/multi-client-k8s:$SHA
docker push $(DOCKER_USERNAME)/multi-server-k8s-pgfix:$SHA
docker push $(DOCKER_USERNAME)/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=$(DOCKER_USERNAME)/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=$(DOCKER_USERNAME)/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=$(DOCKER_USERNAME)/multi-worker-k8s:$SHA