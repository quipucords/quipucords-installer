#!/bin/bash
#
# Installs Discovery quadlets
#
if [ $(id -u) -eq 0 ]; then
  echo "Do not run $0 as root."
  exit 1
fi
podman secret exists discovery-server-password
if [ $? -ne 0 ]; then
  echo "Must create the discovery-server-password secret."
  exit 1
fi
podman secret exists discovery-django-secret-key
if [ $? -ne 0 ]; then
  echo "Must create the discovery-django-secret-key secret."
  exit 1
fi
if [ ! -d ${HOME}/discovery ]; then
  echo "Missing the discovery directory in ${HOME}."
  exit 1
fi
systemctl --user reset-failed
echo "Copying Discovery container and network files to the user systemd configuration ..."
mkdir -p $HOME/.config/containers/systemd/
cd ${HOME}/discovery
cp config/*.network config/*.container $HOME/.config/containers/systemd/
echo "Generate the systemd Discovery services ..."
systemctl --user daemon-reload
echo "Generated Services:"
ls -l ${XDG_RUNTIME_DIR}/systemd/generator/discovery-*.service
echo "Re-starting the Discovery services ..."
systemctl --user reset-failed
echo "  discovery-db ..."
systemctl --user restart discovery-db
echo "  discovery-redis ..."
systemctl --user restart discovery-redis
echo "  discovery-server ..."
systemctl --user restart discovery-server
echo "  discovery-celery-worker ..."
systemctl --user restart discovery-celery-worker
echo "Discovery Services:"
systemctl --user list-units 'discovery-*'

