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

DISCOVERY_LOCAL_FILES="${HOME}/.local/share/discovery"
mkdir -p "${DISCOVERY_LOCAL_FILES}/data"
mkdir -p "${DISCOVERY_LOCAL_FILES}/log"
mkdir -p "${DISCOVERY_LOCAL_FILES}/sshkeys"
mkdir -p "${DISCOVERY_LOCAL_FILES}/certs"

SCRIPT_PATH=`realpath ${BASH_SOURCE[0]}`
DISCOVERY_QUADLETS_ROOT=`dirname $(dirname ${SCRIPT_PATH})`
CONFIG_PATH="${DISCOVERY_QUADLETS_ROOT}/config"
ENV_PATH="${HOME}/.config/discovery/env/"
systemctl --user reset-failed
echo "Copying Discovery container and network files to the user systemd configuration ..."
mkdir -p $HOME/.config/containers/systemd/
mkdir -p $ENV_PATH
cp $CONFIG_PATH/*.network $CONFIG_PATH/*.container $HOME/.config/containers/systemd/
cp $CONFIG_PATH/*.env $ENV_PATH
echo "Generate the systemd Discovery services ..."
systemctl --user daemon-reload
echo "Generated Services:"
ls -l ${XDG_RUNTIME_DIR}/systemd/generator/discovery-*.service
echo "Re-starting the Discovery application ..."
systemctl --user reset-failed
systemctl --user restart discovery-app
echo "Discovery Services:"
systemctl --user list-units 'discovery-*'

