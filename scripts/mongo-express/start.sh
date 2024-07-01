#!/bin/bash

source ./var.sh

CONTAINER_ID=$(docker ps -aq --filter name=${CONTAINER_NAME})
if [[ -z "${CONTAINER_ID}" ]]; then
  echo "Cannot start. No container found."
  exit
fi

echo "Starting container $CONTAINER_ID"
docker start $CONTAINER_ID
