#!/bin/bash -xe

if [ $# -ne 1 ]
  then
    echo "We expect exactly one argument the path to bind mount for dropbox to sync to."
    echo "ex: $0 /dropbox"
    exit 1
fi

MEMORY_LIMIT=512m

docker stop dropbox || true
docker rm dropbox || true

docker run --name=dropbox \
           --detach=true \
           --restart=always \
           --cpus="1.0" \
           --memory=${MEMORY_LIMIT} \
           --mount type=bind,source=$1,target=/home/dropbox/Dropbox \
           docker-dropbox
