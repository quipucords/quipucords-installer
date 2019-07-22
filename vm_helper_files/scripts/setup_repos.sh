#!/bin/bash
set -x

if [ ! -f /etc/redhat-release ]; then
  echo "/etc/redhat-release not found. You need to run this on a Red Hat based OS."
  exit 1
fi

if grep -q -i "release 7" /etc/redhat-release; then
    rpm_version="el7"
elif grep -q -i "release 6" /etc/redhat-release; then
    rpm_version="el6"
else
    rpm_version="el8"
fi

if grep -q -i "Red Hat" /etc/redhat-release; then
    is_rhel="true"
fi


if [[ $is_rhel == "true" ]]
then
    if [[ $rpm_version == "el6" ]]
    then
        sudo cp -rf config/rhel6/*.repo /etc/yum.repos.d/
    elif [[ $rpm_version == "el7" ]]
    then
        sudo cp -rf config/rhel7/*.repo /etc/yum.repos.d/
    else
        sudo cp -rf config/rhel8/*.repo /etc/yum.repos.d/
        sudo subscription-manager register
        sudo subscription-manager attach
    fi
fi
