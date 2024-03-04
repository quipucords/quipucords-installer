#!/bin/bash
echo "Creating Discovery secrets ..."
read -s -p "Enter the Discovery server password: " discovery_server_password
echo
read -s -p "Enter the Discovery Django secret key (development): " discovery_django_secret_key
echo 
if [ -z "${discovery_django_secret_key}" ]; then
  discovery_django_secret_key="development"
fi

podman secret rm discovery-server-password discovery-django-secret-key >/dev/null 2>&1
printf "${discovery_server_password}" | podman secret create discovery-server-password -
printf "${discovery_django_secret_key}" | podman secret create discovery-django-secret-key -
podman secret ls
