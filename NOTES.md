
## Using Systemd to manage Discovery

Discovery deployment on RHEL systems uses Quadlets.
Quadlet is a systemd generator that creates systemd services from container description files.
Generated Services are then managed with systemctl.

After installing Discovery with the discovery-installer RPM, the following systemd services are created:

  - discovery-app
  - discovery-server
  - discovery-celery-worker
  - discovery-db
  - discovery-redis


When running the installer:

- The container and network files are first stored in $HOME/.config/containers/systemd/
for the user running the installer.
- _systemctl --user daemon-reload_ is then run which creates the generated service files in:

```
${XDG_RUNTIME_DIR}/systemd/generator/discovery-*.service
```
i.e. /run/user/\<user_id\>/systemd/generated/discovery-*.sevrvice

#### Showing the Generated Discovery Unit files

$ systemctl --user list-unit-files 'discovery-*'

```
UNIT FILE                       STATE     PRESET
discovery-app.service           generated -     
discovery-celery-worker.service generated -     
discovery-db.service            generated -     
discovery-network.service       generated -     
discovery-redis.service         generated -     
discovery-server.service        generated -

6 unit files listed.
```

$ ls -l ${XDG\_RUNTIME\_DIR}/systemd/generator/discovery-*.service

```
-rw-r--r--. 1 abellotti abellotti 1726 May 14 16:37 /run/user/1001/systemd/generator/discovery-app.service
-rw-r--r--. 1 abellotti abellotti 1882 May 14 16:37 /run/user/1001/systemd/generator/discovery-celery-worker.service
-rw-r--r--. 1 abellotti abellotti 1860 May 14 16:37 /run/user/1001/systemd/generator/discovery-db.service
-rw-r--r--. 1 abellotti abellotti  272 May 14 16:37 /run/user/1001/systemd/generator/discovery-network.service
-rw-r--r--. 1 abellotti abellotti 1113 May 14 16:37 /run/user/1001/systemd/generator/discovery-redis.service
-rw-r--r--. 1 abellotti abellotti 2041 May 14 16:37 /run/user/1001/systemd/generator/discovery-server.service
```

#### Listing Systemd Discovery Service files

$ systemctl --user list-units 'discovery-*'


```
  UNIT                            LOAD   ACTIVE       SUB    JOB     DESCRIPTION                      
______________________________________________________________________________________________________
  discovery-app.service           loaded active running Discovery App
  discovery-celery-worker.service loaded active running Discovery Celery Worker
  discovery-db.service            loaded active running PostgreSQL Database for Discovery
  discovery-network.service       loaded active exited  discovery-network.service
  discovery-redis.service         loaded active running Redis for Discovery
  discovery-server.service        loaded active running Super Discovery Server

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
6 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

#### Listing Status of a service

$ systemctl --user status discovery-server

```
● discovery-server.service - Super Discovery Server
     Loaded: loaded (/home/abellotti/.config/containers/systemd/discovery-server.container; generated)
    Drop-In: /home/abellotti/.config/systemd/user/discovery-server.service.d
             └─override.conf
     Active: active (running) since Tue 2024-05-14 17:03:25 EDT; 1min 45s ago
   Main PID: 218881 (conmon)
      Tasks: 12 (limit: 61091)
     Memory: 846.1M
        CPU: 11.585s
     CGroup: /user.slice/user-1001.slice/user@1001.service/app.slice/discovery-server.service
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

May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [INFO 2024-05-14T21:03:33 pid=71 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [WARNING 2024-05-14T21:03:33 pid=71 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [INFO 2024-05-14T21:03:33 pid=74 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [WARNING 2024-05-14T21:03:33 pid=74 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [INFO 2024-05-14T21:03:33 pid=72 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [WARNING 2024-05-14T21:03:33 pid=72 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [INFO 2024-05-14T21:03:33 pid=70 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [WARNING 2024-05-14T21:03:33 pid=70 tid=281473403133984 s>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [INFO 2024-05-14T21:03:33 pid=75 tid=281473403133984 scan>
May 14 17:03:33 aab-dsc.localdomain discovery-server[218881]: [WARNING 2024-05-14T21:03:33 pid=75 tid=281473403133984 s
```

### Listing Running Podman containers

$ podman ps

```
CONTAINER ID  IMAGE                                          COMMAND               CREATED         STATUS         PORTS                   NAMES
a5b4e2111613  registry.redhat.io/rhel9/redis-6:latest        run-redis             20 minutes ago  Up 20 minutes                          discovery-redis
d9e3349b6258  registry.redhat.io/rhel9/postgresql-15:latest  run-postgresql        20 minutes ago  Up 20 minutes                          discovery-db
5e578d3fb5b3  quay.io/quipucords/quipucords:latest-arm64     /bin/bash /deploy...  6 minutes ago   Up 6 minutes                           discovery-server
5eb28f94762a  quay.io/abellott/quipucords:latest-arm64       /bin/sh -c /deplo...  6 minutes ago   Up 6 minutes                           discovery-celery-worker
8252f28be488  quay.io/abellott/quipucords-ui:latest-arm64    /bin/bash /opt/ap...  6 minutes ago   Up 6 minutes   0.0.0.0:9443->9443/tcp  discovery-app
```

### Verifying the Discovery API is available

$ curl -k https://aab-dsc:9443/api/v1/ping/

```
pong
```

### Viewing all Quadlet logs while starting Discovery

In one terminal window:

$ sudo tail -f /var/log/messages

In another window, start Discovery:

$ systemctl --user start discovery-app

## References:

- https://www.redhat.com/sysadmin/multi-container-application-podman-quadlet
- https://www.redhat.com/sysadmin/quadlet-podman
- https://github.com/containers/podman/blob/main/docs/source/markdown/podman-systemd.unit.5.md
- https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
- https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html
- https://github.com/containers/quadlet/tree/main/docs

