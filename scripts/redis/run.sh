#!/bin/bash

source ./var.sh

docker run \
  -d \
  --name $CONTAINER_NAME \
  --publish 6379:6379 \
  redis
