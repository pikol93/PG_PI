#!/bin/bash

source ./var.sh

docker run \
  -d \
  --name $CONTAINER_NAME \
  --mount type=volume,source=pi-mongodb,target=/etc/mongo \
  --env ME_CONFIG_MONGODB_ADMINUSERNAME=root \
  --env ME_CONFIG_MONGODB_ADMINPASSWORD=root \
  --env ME_CONFIG_BASICAUTH_USERNAME=root \
  --env ME_CONFIG_BASICAUTH_PASSWORD=root \
  --env ME_CONFIG_MONGODB_URL=mongodb://root:root@${MONGO_SERVER}/ \
  --publish 28081:8081 \
  mongo-express
