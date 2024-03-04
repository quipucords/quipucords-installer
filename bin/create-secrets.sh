#!/bin/bash
echo "Creating Discovery secrets ..."
podman secret rm discovery-server-password discovery-django-secret-key >/dev/null 2>&1
printf "superadmin1" | podman secret create discovery-server-password -
printf "development" | podman secret create discovery-django-secret-key -
podman secret ls
