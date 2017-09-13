#!/bin/bash

# Root access is needed
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Do we don't want to use the cache to build the Dockerfile
if [ "$1" == '--no-cache' ]; then
  docker build --no-cache  .
else
  docker build .
fi

# Tag the last image
ID=$(docker images | grep '<none>' | awk '{print $3}')
if [ -n "$ID" ]; then
  docker tag $ID asusk7m550/gitlab-runner:latest
  docker tag $ID asusk7m550/gitlab-runner:$(date +%F)
fi

# Remove old builds
IDS=$(sudo docker images | grep '<none>' | awk '{print $3}')
if [ -n "$IDS" ]; then
  docker rmi $(sudo docker images | grep '<none>' | awk '{print $3}')
fi
