export SVC="${1}"
if [ -z "${SVC}" ]; then
  echo "Must specify which service to restart."
  exit 1
fi
if [ ! -f "discovery-${SVC}.container" ]; then
  echo "Invalid Discovery service ${SVC} specified."
  exit 1
fi
echo "Stopping service discovery-${SVC}.service ..."
systemctl --user stop discovery-${SVC}.service
echo "Starting service discovery-${SVC}.service ..."
systemctl --user start discovery-${SVC}.service
