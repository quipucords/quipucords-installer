export SVC="${1}"
if [ -z "${SVC}" ]; then
  echo "Must specify which service to stop."
  exit 1
fi
echo "Stopping service discovery-${SVC}.service ..."
systemctl --user stop discovery-${SVC}.service
systemctl --user reset-failed
