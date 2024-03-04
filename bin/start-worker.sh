export NUM="${1}"
if [ -z "${NUM}" ]; then
  echo "Must specify which celery worker to start."
  exit 1
fi
echo "Starting celery worker discovery-celery-worker-@${NUM}.service ..."
systemctl --user start "discovery-celery-worker-@${NUM}.service"
