
# Discovery Containers (via. quadlets)

Login as the user that will be running discovery.

Copy the project to $HOME/discovery/

From your .bash_profile add the following:

```
source $HOME/discovery/bin/setup.env
```

## Install discovery:

First login to the registries used so that podman can pull the images.

```
$ podman login registry.redhat.io
$ podman login quay.io
```

  Create the secrets needed by the Discovery server

```
$ create-secrets.sh
```

  Install the Discovery server

```
$ discovery-install.sh
```

Helper shell functions:

```
$ list-dsc            - List Discovery systemd units
$ list-generated-dsc  - List Discovery generated systemd services
$ start-dsc           - Start a Discovery service
$ stop-dsc            - Stop a Discovery service
$ restart-dsc         - Stops then re-Starts a Discovery service
```



## Additional research:

- [ ] Running discovery-db as User, files are somehow created as 100025 and not the user's id.

- [ ] Control service cpu/mem/net limits via cgroups (Control Groups)

- [ ] How customers can specify alternate image repositories

- [ ] How is upgrade handled


## References:

- https://www.redhat.com/sysadmin/multi-container-application-podman-quadlet
- https://www.redhat.com/sysadmin/quadlet-podman
- https://github.com/containers/podman/blob/main/docs/source/markdown/podman-systemd.unit.5.md
- https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
- https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html
- https://github.com/containers/quadlet/tree/main/docs