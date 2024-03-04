export SVC="${1}"
if [ -z "${SVC}" ]; then
  echo "Must specify which service to start."
  exit 1
fi
if [ ! -f "config/discovery-${SVC}.container" ]; then
  echo "Invalid Discovery service ${SVC} specified."
  exit 1
fi
echo "Starting service discovery-${SVC}.service ..."
systemctl --user start discovery-${SVC}.service
