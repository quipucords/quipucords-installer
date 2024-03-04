export NUM="${1}"
if [ -z "${NUM}" ]; then
  echo "Must specify which celery worker to stop."
  exit 1
fi
echo "Stopping celery worker discovery-celery-worker-@${NUM}.service ..."
systemctl --user stop "discovery-celery-worker-@${NUM}.service"
systemctl --user reset-failed
