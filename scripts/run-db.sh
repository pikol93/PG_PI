#!/bin/bash

source ./var-db.sh

docker run \
  -d \
  --name $CONTAINER_NAME \
  --mount type=volume,source=pi-mongodb,target=/etc/mongo \
  --env MONGO_INITDB_ROOT_USERNAME=root \
  --env MONGO_INITDB_ROOT_PASSWORD=root \
  --publish 27017:27017 \
  mongo
