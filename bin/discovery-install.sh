#
# Quadlet is a systemd generator that creates systemd services
# from container description files. Services are then managed by systemctl.
#
# NOTE: rootless could have unreliable networking issues:
#      https://github.com/containers/aardvark-dns/issues/389
#
# For rootless, steps include:
#   - Install the container files as $HOME/.config/containers/systemd/
#   - Reboot system or run "systemctl --user daemon-reload"
#   - This generates system service files
#      i.e. /run/systemd/generator/<svc>.service
#   - Services run under a user id specified.
#
#
# Install the Discovery containers as Systemd services
#
# We get systemd services:
#   discovery-db
#   discovery-redis
#   discovery-server
#   discovery-celery-worker
#
# Which can be managed via systemctl
#
# systemctl list-unit-files 'discovery-*'
#   discovery-db.service                       generated       -       
#   discovery-redis.service                    generated       -
#
# systemctl list-units 'discovery-*'
#   UNIT                    LOAD   ACTIVE SUB     DESCRIPTION                                
# ● discovery-db.service    loaded failed failed  PostgreSQL Database container for Discovery
#   discovery-redis.service loaded active running Redis container for Discovery
#
# systemctl status discovery-redis
# ● discovery-redis.service - Redis container for Discovery
#      Loaded: loaded (/etc/containers/systemd/discovery-redis.container; generated)
#      Active: active (running) since Fri 2024-03-01 18:08:57 EST; 17min ago
#    Main PID: 14548 (conmon)
#       Tasks: 6 (limit: 61081)
#      Memory: 357.8M
#         CPU: 9.191s
#      CGroup: /system.slice/discovery-redis.service
#              ├─libpod-payload-0183521d1862afd6a57f6d13fe172d1c6be1871167511ccb615a8e68b28c6f58
#              │ └─14550 "/usr/bin/redis-server *:6379"
#              └─runtime
#                └─14548 /usr/bin/conmon --api-version 1 -c 0183521d1862afd6a57f6d13fe172d1c6be1871167511ccb615a8e68b28c6f58 -u 018352>
# 
# To zap'em
#   systemctl --user stop <service>
#   rm -f $HOME/.config/containers/systemd/*
#   systemctl --user reset-failed
#   systemctl --user daemon-reload
#
# https://github.com/containers/aardvark-dns/issues/389
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
echo "Copying Discovery container and network files to the user systemd configuration ..."
mkdir -p $HOME/.config/containers/systemd/
cp config/*.network config/*.container $HOME/.config/containers/systemd/
echo "Generate the systemd Discovery services ..."
systemctl --user daemon-reload
echo "Generated Services:"
ls -l /run/user/1001/systemd/generator/discovery-*.service
echo "Starting the Discovery services ..."
systemctl --user reset-failed
systemctl --user start discovery-db
systemctl --user start discovery-redis
systemctl --user start discovery-server
systemctl --user start "discovery-celery-worker-@1"
systemctl --user start "discovery-celery-worker-@2"
systemctl --user start "discovery-celery-worker-@3"
echo "Discovery Services:"
systemctl --user list-units 'discovery-*'

