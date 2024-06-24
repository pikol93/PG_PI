#!/bin/bash

source ./var-db.sh

CONTAINER_ID=$(docker ps -aq --filter name=${CONTAINER_NAME})
if [[ -z "${CONTAINER_ID}" ]]; then
  echo "Cannot remove. No container found."
  exit
fi

echo "Removing container $CONTAINER_ID"
docker rm $CONTAINER_ID
