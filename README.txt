
Copy the project to $HOME/discovery/

From your .bash_profile add the following:

  source $HOME/discovery/bin/setup.env

Install discovery:

  First login to the registries used so that podman can pull the images.

  $ podman login registry.redhat.io
  $ podman login quay.io

  Create the secrets needed by the Discovery server

  $ create-secrets.sh

  Install the Discovery server

  $ discovery-install.sh

Helper shell functions:

  $ list-dsc            - List Discovery systemd units
  $ list-generated-dsc  - List Discovery generated systemd services
  $ start-dsc           - Start a Discovery service
  $ stop-dsc            - Stop a Discovery service
  $ restart-dsc         - Stop the re-Starts a Discovery service

Additional research:
- Running discovery-db as User, files are somehow created as 100025 and not 1001.
- Control service cpu/mem/net limits via cgroups (Control Groups)
- How customers can specify alternate image repositories
- How is upgrade handled

