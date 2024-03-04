#!/bin/bash
#
# List Discovery quadlet services
#
systemctl --user list-units 'discovery-*'
