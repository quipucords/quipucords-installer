export SVC="${1}"
if [ -z "${SVC}" ]; then
  echo "Must specify which service to restart."
  exit 1
fi
echo "Stopping service discovery-${SVC} ..."
systemctl --user stop discovery-${SVC}
echo "Starting service discovery-${SVC} ..."
systemctl --user start discovery-${SVC}
