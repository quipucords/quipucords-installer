# Installing Quipucords using `quipucords-installer`

## What is this?

`quipucords-installer` is a small bundle of commands and templates that you can use to install and configure Quipucords and all its required components to run in Podman containers on your local system.

## Using the RPM

> [!IMPORTANT]
> Installing the `quipucords-installer` RPM itself requires `sudo` or elevated `root` privileges, but ***all other commands*** for installing and interacting with Quipucords through the `quipucords-installer` program should be executed as a *regular non-root* user. If you install and run Quipucords as `root`, expect no support from the maintainers.

To prepare `quipucords-installer`:
```sh
sudo dnf copr enable -y @quipucords/quipucords-installer
sudo dnf install -y quipucords-installer
```

To install, configure, and start Quipucords:
```sh
quipucords-installer install
podman login registry.redhat.io  # REQUIRED before starting quipucords-app
systemctl --user start quipucords-app
```

A few seconds later, you may access Quipucords on https://localhost:9443

If you want to access Quipucords from systems outside of localhost, you may need to add a rule to allow access through the firewall:

```sh
sudo firewall-cmd --permanent --add-port=9443/tcp  # optional if you want external access
sudo firewall-cmd --reload  # optional if you want external access
```

## Running from source (developers only)

Alternatively, if you are a Quipucords developer and need to run this repo from source:

```sh
git clone https://github.com/quipucords/quipucords-installer.git quipucords-installer
cd quipucords-installer
QUIPUCORDS_PKG_ROOT=$(pwd) ./bin/quipucords-installer install
podman login registry.redhat.io  # REQUIRED before starting quipucords-app
systemctl --user start quipucords-app
```

A few seconds (or minutes depending on your hardware) later, you may access Quipucords on https://localhost:9443

## Contributing

**Note**: If you use AI tools to generate code, please review our [Policy for AI-Generated Code](AI-POLICY.md) for disclosure and quality requirements.

## Accessing Quipucords

You can access Quipucords on the host where it was installed at https://localhost:9443.

If that host has a custom hostname, such as `my-server`, and you have added appropriate firewall rules, you may be able to access Quipucords from other systems on your network at https://my-server:9443 or https://my-server.local:9443. Further hostname, DNS, firewall, and network configuration instructions are outside the scope of this document and not officially supported.

## Stopping Quipucords

Quipucords is managed via the **quipucords-app.service** systemd unit. Related service units declare dependencies such that this one service is responsible for all Quipucords service orchestration.

To stop Quipucords and all its supporting services:

```sh
systemctl --user stop quipucords-app
```

## Restarting Quipucords

To restart all Quipucords services:

```sh
systemctl --user restart quipucords-app
```

## Uninstall and cleanup

To stop Quipucords, uninstall it, and remove related files, simply run:

```sh
quipucords-installer uninstall
```
```
Stopping Quipucords ...
Removing Quipucords Services ...
Removing Quipucords Data ...
Quipucords Uninstalled.
```

That command should stop any running containers belonging to Quipucords, remove saved Podman secrets, remove systemd unit files, and remove Quipucords's logs and data.

## Troubleshooting

What if you cannot access the web UI or API on https://localhost:9443?


After installing and starting Quipucords, check that the following services are defined:

```sh
systemctl --user list-units 'quipucords-*'
```
```
  UNIT                             LOAD   ACTIVE SUB     DESCRIPTION
  quipucords-app.service           loaded active running Quipucords App
  quipucords-celery-worker.service loaded active running Quipucords Celery Worker
  quipucords-db.service            loaded active running PostgreSQL Database for Quipucords
  quipucords-network.service       loaded active exited  quipucords-network.service
  quipucords-redis.service         loaded active running Redis for Quipucords
  quipucords-server.service        loaded active running Quipucords Server

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.

6 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

`quipucords-network` should report `loaded active exited` and all other units should report `loaded active running`.

Check that systemd reports that each component service is `active (running)`:

```sh
systemctl --user status quipucords-app
systemctl --user status quipucords-db
systemctl --user status quipucords-redis
systemctl --user status quipucords-server
systemctl --user status quipucords-celery-worker
```

Check that Podman reports each container is running without error:

```sh
podman ps -a
podman inspect quipucords-app | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect quipucords-db | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect quipucords-redis | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect quipucords-server | jq '.[].State | {Status, Running, Error, ExitCode}'
podman inspect quipucords-celery-worker | jq '.[].State | {Status, Running, Error, ExitCode}'
```

Check the systemd journal for any errors or interesting log messages:

```sh
journalctl --user -u podman
journalctl --user -u quipucords-server
journalctl --user -u quipucords-db
journalctl --user -u quipucords-redis
journalctl --user -u quipucords-server
journalctl --user -u quipucords-celery-worker
```

Did some containers start but not all? Are the `quipucords-db` and `quipucords-redis` containers missing? You may have forgotten to `podman login` or your auth token has expired. Log in again, and restart the app:

```sh
podman login registry.redhat.io  # REQUIRED before starting quipucords-app
systemctl --user restart quipucords-app
```

Are you trying to access Quipucords from outside localhost? Check that the correct port/protocol is open, and add rules if necessary:

```sh
sudo firewall-cmd --list-ports
```

Can you access Quipucords via the web UI or CLI, but you cannot log in? You may have forgotten your password, or the password you set during the `install` command was too weak. Reset your password, and restart the app:

```sh
quipucords-installer create-server-password
systemctl --user restart quipucords-app
```

Still can't login? If the password you set it too weak, Quipucords will reset it to a new strong random password upon startup. Check for recent messages like this in the server logs:

```sh
journalctl --user -u quipucords-server | grep password
```
```
QUIPUCORDS_SERVER_PASSWORD value failed password requirements. Using a randomly generated password instead.
Updated user 'admin' with random password: jbzRwrvjnw
```

You may use the logged randomly-generated password *temporarily*, but beware that if you do not set a properly strong password directly, the random password will regenerate itself the next time Quipucords restarts.

Did you run `quipucords-installer install` as a regular user or as root? You should always run the installer and Podman commands as a regular user, *NEVER as the root user*. Run the uninstall command, and start over as a non-root user.

## Securing Quipucords HTTPS

When running Quipucords, a self-signed certificate is created for accessing the web UI and API and is stored in the running host's `~/.local/share/quipucords/certs/` directory. You may provide your own HTTPS certificate and key in this location before starting Quipucords:

- `~/.local/share/quipucords/certs/server.crt`
- `~/.local/share/quipucords/certs/server.key`

## Quipucords Service Orchestration

Quipucords's services are managed by systemd with the following relationships:

- **quipucords-app.service**
  - Depends on and automatically starts and stops:
      - quipucords-server
      - quipucords-celery-worker
      - quipucords-redis
      - quipucords-db
  - Starts After:
      - quipucords-server

- **quipucords-celery-worker.service**
  - Starts After:
      - quipucords-server

- **quipucords-server.service**
  - Starts After:
      - quipucords-db
      - quipucords-redis

- **quipucords-redis.service**

- **quipucords-db.service**
