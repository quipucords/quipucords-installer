export WORKERS="${@}"
if [ -z "${WORKERS}" ]; then
  echo "Must specify which celery workers to start."
  exit 1
fi
for WORKER in ${WORKERS}
do
  echo "Starting celery worker discovery-celery-worker-@${WORKER}.service ..."
  systemctl --user start "discovery-celery-worker-@${WORKER}.service"
done
exit 0
