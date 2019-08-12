#!/bin/bash
set -x

sudo yum -y erase qpc
docker rm -f $(docker ps -a -q) | true
docker rmi $(docker images -q) | true
podman rm -af | true
podman rmi -a | true