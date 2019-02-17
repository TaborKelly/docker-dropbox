#!/bin/bash -xe

if [ $# -ne 1 ]
  then
    echo "We expect exactly one argument the path to bind mount for dropbox to sync to."
    echo "ex: $0 /dropbox"
    exit 1
fi

MEMORY_LIMIT=512m

docker run --name=dropbox \
           --detach=true \
           --restart=always \
           --memory=${MEMORY_LIMIT} \
           --mount type=bind,source=$1,target=/dropbox \
           docker-dropbox
