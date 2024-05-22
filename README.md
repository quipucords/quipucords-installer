
## Installing Discovery using the RPM Installer

## Deploying Discovery

Deploying Discovery via Quadlet is performed via an RPM based installer. The following is an example of how to install discovery:

You must be running the following commands as root to install the discovery installer via the RPM:

```
# subscription-manager repos --enable discovery-1-for-rhel-9-x86_64-rpms
# dnf install -y discovery-installer
```

```
# type discovery-installer
discovery-installer is /usr/bin/discovery-installer
```

Discovery must then be installed as a regular (non-root) user in the system. For the following examples we will use the username **discovery**

Log in to the _discovery_ user account then install Discovery:

```
discovery $ pwd
/home/discovery
discovery $ type discovery-installer
discovery-installer is /usr/bin/discovery-installer
discovery $ discovery-installer
Usage: discovery-installer [-v | --verbose] <command>

Where <command> is one of:
  install                  - Install Discovery
  uninstall                - Uninstall Discovery
  create-server-password   - Create a Discovery server password
  create-app-secret        - Create a Discovery application secret
```

## Discovery Pre-requisites

### Podman Secrets

Before starting Discovery you need to create the following _podman_ secrets:

- discovery-server-password
  - The Discovery Console admin password
- discovery-django-secret-key
  - The Discovery application secret key for this deployment

Running *discovery-installer* install first requires the server password and application secrets to be created. if not detected, the installer will require those to be done first.

```
abellotti $ discovery-installer install
Must create the discovery-server-password secret before installing Discovery.
Run discovery-installer create-server-password
```

```
abellotti $ discovery-installer create-server-password
Enter the Discovery server password: 
Re-enter the password: 
1894eb784d888afbabdc6eaa4
ID                         NAME                       DRIVER      CREATED                 UPDATED
1894eb784d888afbabdc6eaa4  discovery-server-password  file        Less than a second ago  Less than a second ago
```

```
abellotti $ discovery-installer install
Must create the discovery-django-secret-key secret before installing Discovery.
Run discovery-installer create-app-secret
```

```
abellotti $ discovery-installer create-app-secret
Enter the Discovery Django secret key (development): 
7add5731b86406497f046ade9
ID                         NAME                         DRIVER      CREATED                 UPDATED
7add5731b86406497f046ade9  discovery-django-secret-key  file        Less than a second ago  Less than a second ago
```

### Registry Access


For starting Discovery, the quadlets will be downloading the necessary images from **registry.redhat.io**, you need to login to that registry first:

```
discovery $ podman login registry.redhat.io
Username: {your_registry_redhat_io_username}
Password:
Login Succeeded!
discovery $
```

*Note*: If you are installing an upstream release of Discovery you also need to _podman login_ to **quay.io**



### Firewall

For accessing the Discovery Console, make sure the 9443 port that is exposed and published by the discovery-app quadlet is accessible:


This can be done by running the following commands as root:

```
# firewall-cmd --permanent --add-port=9443/tcp
# firewall-cmd --reload
```

*Note*: the firewall-cmd command is provided by the _firewalld_ RPM package.


## Installing Discovery


```
discovery $ discovery-installer install
Installing Discovery configuration files ...
Generate the Discovery services ...
Discovery Installed.
discovery $
```

The necessary volume mount directories for Discovery would be created during the install:

```
discovery $ ls -FC ~/.local/share/discovery
certs/ data/ log/ sshkeys/
discovery $
```

When running Discovery, a self-signed certificate is created for accessing the Console and API and stored in the ~/.local/share/discovery/certs/ directory. A customer provided/signed certificate can also be placed there before starting Discovery

- server.crt
- server.key

### Quadlet Services

After installing Discovery, the following Quadlet services and shared network are defined:

```
discovery $ systemctl --user list-units 'discovery-*'
  UNIT                            LOAD   ACTIVE SUB     DESCRIPTION                      
  discovery-app.service           loaded active running Discovery App
  discovery-celery-worker.service loaded active running Discovery Celery Worker
  discovery-db.service            loaded active running PostgreSQL Database for Discovery
  discovery-network.service       loaded active exited  discovery-network.service
  discovery-redis.service         loaded active running Redis for Discovery
  discovery-server.service        loaded active running Discovery Server

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
6 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

Starting and stopping Discovery is managed via the **discovery-app.service** service. It declares its dependencies to the other quadlets and is responsible for the Discovery quadlet orchestration.

### Discovery Quadlet Orchestration

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



## Starting Discovery

Starting Discovery and all related quadlets is done via the _discovery-app_ quadlet as follows:

```
discovery $ systemctl --user start discovery-app
discovery $
```


## Accessing Discovery

You can access the Discovery console on the Machine hosting the Discovery Quadlet Services by opening up a browser and accessing port 9443.

In this example, the host name is aab-dsc, so simply access the following URL:

```
https://aab-dsc:9443
```


## Stopping Discovery

Stopping Discovery and all related quadlets is done as follows:

```
discovery $ systemctl --user stop discovery-app
discovery $
```

## Uninstalling Discovery

For uninstalling Discovery and all related files and services, run the following command:

```
discovery $ discovery-installer uninstall
Stopping Discovery ...
Removing Discovery Services ...
Removing Discovery Data ...
Discovery Uninstalled.
discovery $
```

