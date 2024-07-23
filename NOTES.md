
## Using Systemd to manage Quipucords

Quipucords deployment on RHEL systems uses Quadlets.
Quadlet is a systemd generator that creates systemd services from container description files.
Generated Services are then managed with systemctl.

After installing Quipucords with the quipucords-installer RPM, the following systemd services are created:

  - quipucords-app
  - quipucords-server
  - quipucords-celery-worker
  - quipucords-db
  - quipucords-redis


When running the installer:

- The container and network files are first stored in $HOME/.config/containers/systemd/
for the user running the installer.
- _systemctl --user daemon-reload_ is then run which creates the generated service files in:

```
${XDG_RUNTIME_DIR}/systemd/generator/quipucords-*.service
```
i.e. /run/user/\<user_id\>/systemd/generated/quipucords-*.sevrvice

#### Showing the Generated Quipucords Unit files

$ systemctl --user list-unit-files 'quipucords-*'

```
UNIT FILE                       STATE     PRESET
quipucords-app.service           generated -
quipucords-celery-worker.service generated -
quipucords-db.service            generated -
quipucords-network.service       generated -
quipucords-redis.service         generated -
quipucords-server.service        generated -

6 unit files listed.
```

$ ls -l ${XDG\_RUNTIME\_DIR}/systemd/generator/quipucords-*.service

```
-rw-r--r--. 1 abellotti abellotti 1726 May 14 16:37 /run/user/1001/systemd/generator/quipucords-app.service
-rw-r--r--. 1 abellotti abellotti 1882 May 14 16:37 /run/user/1001/systemd/generator/quipucords-celery-worker.service
-rw-r--r--. 1 abellotti abellotti 1860 May 14 16:37 /run/user/1001/systemd/generator/quipucords-db.service
-rw-r--r--. 1 abellotti abellotti  272 May 14 16:37 /run/user/1001/systemd/generator/quipucords-network.service
-rw-r--r--. 1 abellotti abellotti 1113 May 14 16:37 /run/user/1001/systemd/generator/quipucords-redis.service
-rw-r--r--. 1 abellotti abellotti 2041 May 14 16:37 /run/user/1001/systemd/generator/quipucords-server.service
```

#### Listing Systemd Quipucords Service files

$ systemctl --user list-units 'quipucords-*'


```
  UNIT                            LOAD   ACTIVE       SUB    JOB     DESCRIPTION
______________________________________________________________________________________________________
  quipucords-app.service           loaded active running Quipucords App
  quipucords-celery-worker.service loaded active running Quipucords Celery Worker
  quipucords-db.service            loaded active running PostgreSQL Database for Quipucords
  quipucords-network.service       loaded active exited  quipucords-network.service
  quipucords-redis.service         loaded active running Redis for Quipucords
  quipucords-server.service        loaded active running Super Quipucords Server

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
6 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

#### Listing Status of a service

$ systemctl --user status quipucords-server

```
● quipucords-server.service - Super Quipucords Server
     Loaded: loaded (/home/abellotti/.config/containers/systemd/quipucords-server.container; generated)
    Drop-In: /home/abellotti/.config/systemd/user/quipucords-server.service.d
             └─override.conf
     Active: active (running) since Tue 2024-05-14 17:03:25 EDT; 1min 45s ago
   Main PID: 218881 (conmon)
      Tasks: 12 (limit: 61091)
     Memory: 846.1M
        CPU: 11.585s
     CGroup: /user.slice/user-1001.slice/user@1001.service/app.slice/quipucords-server.service
             ├─libpod-payload-5e578d3fb5b38f5bf3c434def6348d939b9bac4bef710e794a0d9c42b31f6ec0
             │ ├─218883 /bin/bash /deploy/entrypoint_web.sh
             │ ├─219199 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219200 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219201 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219202 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219204 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219205 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219206 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219207 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ ├─219208 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             │ └─219209 /opt/venv/bin/python3.11 /opt/venv/bin/gunicorn quipucords.wsgi -c /deploy/gunicorn_conf.py
             └─runtime
               └─218881 /usr/bin/conmon --api-version 1 -c 5e578d3fb5b38f5bf3c434def6348d939b9bac4bef710e794a0d9c42b31f>

May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [INFO 2024-05-14T21:03:33 pid=71 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [WARNING 2024-05-14T21:03:33 pid=71 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [INFO 2024-05-14T21:03:33 pid=74 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [WARNING 2024-05-14T21:03:33 pid=74 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [INFO 2024-05-14T21:03:33 pid=72 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [WARNING 2024-05-14T21:03:33 pid=72 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [INFO 2024-05-14T21:03:33 pid=70 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [WARNING 2024-05-14T21:03:33 pid=70 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [INFO 2024-05-14T21:03:33 pid=75 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain quipucords-server[218881]: [WARNING 2024-05-14T21:03:33 pid=75 tid=281473403133984 s
```

### Listing Running Podman containers

$ podman ps

```
CONTAINER ID  IMAGE                                          COMMAND               CREATED         STATUS         PORTS                   NAMES
a5b4e2111613  registry.redhat.io/rhel9/redis-6:latest        run-redis             20 minutes ago  Up 20 minutes                          quipucords-redis
d9e3349b6258  registry.redhat.io/rhel9/postgresql-15:latest  run-postgresql        20 minutes ago  Up 20 minutes                          quipucords-db
5e578d3fb5b3  quay.io/quipucords/quipucords:latest-arm64     /bin/bash /deploy...  6 minutes ago   Up 6 minutes                           quipucords-server
5eb28f94762a  quay.io/abellott/quipucords:latest-arm64       /bin/sh -c /deplo...  6 minutes ago   Up 6 minutes                           quipucords-celery-worker
8252f28be488  quay.io/abellott/quipucords-ui:latest-arm64    /bin/bash /opt/ap...  6 minutes ago   Up 6 minutes   0.0.0.0:9443->9443/tcp  quipucords-app
```

### Verifying the Quipucords API is available

$ curl -k https://aab-dsc:9443/api/v1/ping/

```
pong
```

### Viewing all Quadlet logs while starting Quipucords

In one terminal window:

$ sudo tail -f /var/log/messages

In another window, start Quipucords:

$ systemctl --user start quipucords-app

## References:

- https://www.redhat.com/sysadmin/multi-container-application-podman-quadlet
- https://www.redhat.com/sysadmin/quadlet-podman
- https://github.com/containers/podman/blob/main/docs/source/markdown/podman-systemd.unit.5.md
- https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
- https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html
- https://github.com/containers/quadlet/tree/main/docs

