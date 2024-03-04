#!/bin/bash
#
# Script to scale up the celery workers to the minimum
# number of celery workers we want.
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/../config/env-server.env
for WORKER in $(seq 1 ${QPC_MIN_CELERY_WORKERS})
do
  echo "Starting celery worker discovery-celery-worker-@${WORKER}.service ..."
  systemctl --user start "discovery-celery-worker-@${WORKER}.service"
done
exit 0
