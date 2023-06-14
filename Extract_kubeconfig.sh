#!/bin/bash

# Get the container ID of the first container that matches the name
CONTAINER_ID=$(docker ps -q -f name=kinda)

# Copy the kubeconfig file from the container to the host
docker cp $CONTAINER_ID:/etc/kubernetes/admin.conf.

# Display the contents of the kubeconfig file
cat admin.conf