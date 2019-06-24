#!/bin/bash
set -x

if [ ! -f /etc/redhat-release ]; then
  echo "/etc/redhat-release not found. You need to run this on a Red Hat based OS."
  exit 1
fi

if grep -q -i "release 7" /etc/redhat-release; then
    rpm_version="el7"
else
    rpm_version="el6"
fi

if grep -q -i "Red Hat" /etc/redhat-release; then
    is_rhel="true"
fi


if [[ $is_rhel == "true" ]]
then
    sudo cp -rf config/repos/*.repo /etc/yum.repos.d/
fi
