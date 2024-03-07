
Quadlet is a systemd generator that creates systemd services
from container description files.
Generated Services are then managed by systemctl.



For rootless, steps include:

  - Install the container files as $HOME/.config/containers/systemd/
  - Reboot system or run "systemctl --user daemon-reload"
  - This generates system service files in:
  
        ${XDG_RUNTIME_DIR}/systemd/generator/discovery-*.service
     i.e. /run/user/__<user_id>__/systemd/generator/discovery-*.service

  - Services run under the current user id.


Install the Discovery containers as Systemd services

We get systemd services:

  - discovery-db
  - discovery-redis
  - discovery-server
  - discovery-celery-worker

Which can be managed via systemctl

$ systemctl --user list-unit-files 'discovery-*'

```
UNIT FILE                         STATE     PRESET
discovery-celery-worker-@.service generated -     
discovery-db.service              generated -     
discovery-network.service         generated -     
discovery-redis.service           generated -     
discovery-server.service          generated -     

5 unit files listed.
```


$ systemctl --user list-units 'discovery-*'


```
UNIT                               LOAD   ACTIVE SUB     DESCRIPTION                      
discovery-celery-worker-@1.service loaded active running Discovery Celery Worker #1
discovery-celery-worker-@2.service loaded active running Discovery Celery Worker #2
discovery-celery-worker-@3.service loaded active running Discovery Celery Worker #3
discovery-db.service               loaded active running PostgreSQL Database for Discovery
discovery-network.service          loaded active exited  discovery-network.service
discovery-redis.service            loaded active running Redis for Discovery
discovery-server.service           loaded active running Discovery Server
```


$ systemctl --user status discovery-redis

```
abellotti $ systemctl --user status discovery-redis
● discovery-redis.service - Redis for Discovery
     Loaded: loaded (/home/abellotti/.config/containers/systemd/discovery-redis.container; generated)
     Active: active (running) since Thu 2024-03-07 12:31:00 EST; 1h 19min ago
   Main PID: 35954 (conmon)
      Tasks: 21 (limit: 61081)
     Memory: 35.8M
        CPU: 26.998s
     CGroup: /user.slice/user-1001.slice/user@1001.service/app.slice/discovery-redis.service
             ├─libpod-payload-86b9a13a056bb3022588354b292838876dea5cbf5f8ab860460eccb4b96ba403
             │ └─35956 "/usr/bin/redis-server *:6379"
             └─runtime
               ├─35937 rootlessport
               ├─35944 rootlessport-child
               └─35954 /usr/bin/conmon --api-version 1 -c 86b9a13a056bb3022588354b292838876dea5cbf5f8ab860460eccb4b96ba403 -u 86b9a13a056bb3022588354b292838876de>

Mar 07 12:58:32 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 17:58:32.610 * 100 changes in 300 seconds. Saving...
Mar 07 12:58:32 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 17:58:32.615 * Background saving started by pid 14
Mar 07 12:58:32 aab-dsc.localdomain discovery-redis[35954]: 14:C 07 Mar 2024 17:58:32.628 * DB saved on disk
Mar 07 12:58:32 aab-dsc.localdomain discovery-redis[35954]: 14:C 07 Mar 2024 17:58:32.628 * RDB: 0 MB of memory used by copy-on-write
Mar 07 12:58:32 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 17:58:32.717 * Background saving terminated with success
Mar 07 13:26:44 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 18:26:44.594 * 100 changes in 300 seconds. Saving...
Mar 07 13:26:44 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 18:26:44.595 * Background saving started by pid 15
Mar 07 13:26:44 aab-dsc.localdomain discovery-redis[35954]: 15:C 07 Mar 2024 18:26:44.600 * DB saved on disk
Mar 07 13:26:44 aab-dsc.localdomain discovery-redis[35954]: 15:C 07 Mar 2024 18:26:44.601 * RDB: 0 MB of memory used by copy-on-write
Mar 07 13:26:44 aab-dsc.localdomain discovery-redis[35954]: 1:M 07 Mar 2024 18:26:44.699 * Background saving terminated with success
```

To zap services, use the stop subcommand of systemctl.

i.e.

```
$ systemctl --user stop <service>
$ rm -f $HOME/.config/containers/systemd/*
$ systemctl --user reset-failed
$ systemctl --user daemon-reload
```

_NOTE_: rootless could have unreliable networking issues:

     See: https://github.com/containers/aardvark-dns/issues/389

