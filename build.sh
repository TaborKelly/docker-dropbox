#!/bin/bash -xe

# This is important for cron to run
chmod 0644 assets/*

docker build --tag docker-dropbox .
