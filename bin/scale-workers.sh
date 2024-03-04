#!/bin/bash
#
# Script to scale up the celery workers to the minimum
# number of celery workers we want.
#
BASEDIR=$(dirname $0)
source ${BASEDIR}/../config/env-server.env
NUM_WORKERS="${QPC_MIN_CELERY_WORKERS}"
if [ -n "${1}" ]; then
  NUM_WORKERS="${1}"
fi
if [[ ${NUM_WORKERS} -gt ${QPC_MAX_CELERY_WORKERS} ]]; then
  echo "Failed to scale the Discovery workers, maximum number of instances is ${QPC_MAX_CELERY_WORKERS}"
  exit 1
fi

echo "Scaling Discovery Celery Workers discovery-celery-worker-@.service ..."
echo -n "Starting celery workers: "
for WORKER in $(seq 1 ${NUM_WORKERS})
do
  echo -n "${WORKER} "
  systemctl --user start "discovery-celery-worker-@${WORKER}.service"
done
echo

echo -n "Stopping celery workers: "
for WORKER in $(seq ${NUM_WORKERS} ${QPC_MAX_CELERY_WORKERS})
do
  if [[ ${WORKER} -gt ${NUM_WORKERS} ]]; then
    echo -n "${WORKER} "
    systemctl --user stop "discovery-celery-worker-@${WORKER}.service"
  fi
done
echo
exit 0
