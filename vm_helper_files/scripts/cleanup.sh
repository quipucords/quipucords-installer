#!/bin/bash
set -x

sudo yum -y erase qpc
docker rm -f $(docker ps -a -q)
docker rmi $(docker images -q)
