export WORKERS="${@}"
if [ -z "${WORKERS}" ]; then
  echo "Must specify which celery workers to stop."
  exit 1
fi
for WORKER in ${WORKERS} 
do
  echo "Stopping celery worker discovery-celery-worker-@${WORKER}.service ..."
  systemctl --user stop "discovery-celery-worker-@${WORKER}.service"
done
systemctl --user reset-failed
