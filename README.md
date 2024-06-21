# Installing Discovery using `discovery-installer`

## Using the official RPM

Unless specifically noted with `sudo`, ***all commands*** for installing and interacting with Discovery through this installer should be executed as a *regular non-root* user. If you install and run Discovery as `root`, expect no support from the maintainers.

To use the the official installer to install, configure, and run Discovery:

```sh
sudo subscription-manager repos --enable discovery-1-for-rhel-9-x86_64-rpms
sudo dnf install -y discovery-installer
discovery-installer install
podman login registry.redhat.io  # REQUIRED before starting discovery-app
systemctl --user start discovery-app
```

A few seconds later, you may access Discovery on https://localhost:9443

If you want to access Discovery from systems outside of localhost, you may need to add a rule to allow access through the firewall:

```sh
sudo firewall-cmd --permanent --add-port=9443/tcp  # optional if you want external access
sudo firewall-cmd --reload  # optional if you want external access
```

## Running from source (developers only)

Alternatively, if you are a Discovery developer and need to run this repo from source:

```sh
git clone https://github.com/quipucords/discovery-quadlets.git discovery-quadlets
cd discovery-quadlets
DISCOVERY_PKG_ROOT=$(pwd) ./bin/discovery-installer install
podman login registry.redhat.io  # REQUIRED before starting discovery-app
systemctl --user start discovery-app
```

A few seconds (or minutes depending on your hardware) later, you may access Discovery on https://localhost:9443

## Accessing Discovery

You can access Discovery on the host where it was installed at https://localhost:9443.

If that host has a custom hostname, such as `my-discovery-server`, and you have added appropriate firewall rules, you may be able to access Discovery from other systems on your network at https://my-discovery-server:9443 or https://my-discovery-server.local:9443. Further hostname, DNS, firewall, and network configuration instructions are outside the scope of this document and not officially supported.


## Stopping Discovery

Discovery is managed via the **discovery-app.service** systemd unit. Related service units declare dependencies such that this one service is responsible for all Discovery service orchestration.

To stop Discovery and all its supporting services:

```sh
systemctl --user stop discovery-app
```

## Restarting Discovery

To restart all Discovery services:

```sh
systemctl --user restart discovery-app
```

## Uninstall and cleanup

To stop Discovery, uninstall it, and remove related files, simply run:

```sh
discovery-installer uninstall
```
```
Stopping Discovery ...
Removing Discovery Services ...
Removing Discovery Data ...
Discovery Uninstalled.
```

That command should stop any running containers belonging to Discovery, remove saved podman secrets, remove systemd unit files, and remove Discovery's logs and data.

## Troubleshooting

What if you cannot access the web UI or API on https://localhost:9443?


After installing and starting Discovery, check that the following services are defined:

```sh
systemctl --user list-units 'discovery-*'
```
```
  UNIT                            LOAD   ACTIVE SUB     DESCRIPTION
  discovery-app.service           loaded active running Discovery App
  discovery-celery-worker.service loaded active running Discovery Celery Worker
  discovery-db.service            loaded active running PostgreSQL Database for Discovery
  discovery-network.service       loaded active exited  discovery-network.service
  discovery-redis.service         loaded active running Redis for Discovery
  discovery-server.service        loaded active running Discovery Server

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.

6 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

`discovery-network` should report `loaded active exited` and all other units should report `loaded active running`.

Check that systemd reports that each component service is `active (running)`:

```sh
systemctl --user status discovery-app
systemctl --user status discovery-db
systemctl --user status discovery-redis
systemctl --user status discovery-server
systemctl --user status discovery-celery-worker
```

Check that podman reports each container is running without error:

```sh
podman ps -a
podman inspect discovery-app | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect discovery-db | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect discovery-redis | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect discovery-server | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect discovery-celery-worker | jq '.[].State | {Status, Running, Error, ExitCode}'
```

Check the systemd journal for any errors or interesting log messages:

```sh
journalctl --user -u podman
journalctl --user -u discovery-server
journalctl --user -u discovery-db
journalctl --user -u discovery-redis
journalctl --user -u discovery-server
journalctl --user -u discovery-celery-worker
```

Did some containers start but not all? Are the `discovery-db` and `discovery-redis` containers missing? You may have forgotten to `podman login` or your auth token has expired. Log in again, and restart the app:

```sh
podman login registry.redhat.io  # REQUIRED before starting discovery-app
systemctl --user restart discovery-app
```

Are you trying to access Discovery from outside localhost? Check that the correct port/protocol is open, and add rules if necessary:

```sh
sudo firewall-cmd --list-ports
```

Can you access Discovery via the web UI or CLI, but you cannot log in? You may have forgotten your password, or the password you set during the `install` command was too weak. Reset your password, and restart the app:

```sh
discovery-installer create-server-password
systemctl --user restart discovery-app
```

Still can't login? If the password you set it too weak, Discovery will reset it to a new strong random password upon startup. Check for recent messages like this in the server logs:

```sh
journalctl --user -u discovery-server | grep password
```
```
QPC_SERVER_PASSWORD value failed password requirements. Using a randomly generated password instead.
Updated user 'admin' with random password: jbzRwrvjnw
```

You may use the logged randomly-generated password *temporarily*, but beware that if you do not set a properly strong password directly, the random password will regenerate itself the next time Discovery restarts.

Did you run `discovery-installer install` as a regular user or as root? You should always run the installer and podman commands as a regular user, *NEVER as the root user*. Run the uninstall command, and start over as a non-root user.

## Securing Discovery HTTPS

When running Discovery, a self-signed certificate is created for accessing the web UI and API and is stored in the running host's `~/.local/share/discovery/certs/` directory. You may provide your own HTTPS certificate and key in this location before starting Discovery:

- `~/.local/share/discovery/certs/server.crt`
- `~/.local/share/discovery/certs/server.key`

## Discovery Service Orchestration

Discovery's services are managed by systemd with the following relationships:

- **discovery-app.service**
  - Depends on and automatically starts and stops:
      - discovery-server
      - discovery-celery-worker
      - discovery-redis
      - discovery-db
  - Starts After:
      - discovery-server

- **discovery-celery-worker.service**
  - Starts After:
      - discovery-server

- **discovery-server.service**
  - Starts After:
      - discovery-db
      - discovery-redis

- **discovery-redis.service**

- **discovery-db.service**
