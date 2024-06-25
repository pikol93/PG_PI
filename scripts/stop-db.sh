#!/bin/bash

source ./var-db.sh

CONTAINER_ID=$(docker ps -aq --filter name=${CONTAINER_NAME})
if [[ -z "${CONTAINER_ID}" ]]; then
  echo "Cannot stop. No container found."
  exit
fi

echo "Stopping container $CONTAINER_ID"
docker stop $CONTAINER_ID
