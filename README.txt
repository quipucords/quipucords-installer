
Copy the project to $HOME/discovery/

From your .bash_profile add the following:

  source $HOME/discovery/bin/setup.env

Install discovery:

  $ create-secrets.sh
  $ discovery-install.sh

Helper shell functions:

  list-dsc            - List Discovery systemd units
  list-generated-dsc  - List Discovery generated systemd services
  start-dsc           - Start a Discovery service
  stop-dsc            - Stop a Discovery service
  restart-dsc         - Stop the re-Starts a Discovery service

Open Issues:
- Running discovery-db as User, files are somehow created as 100025 and not 1001.
- Control service cpu/mem/net limits via cgroups (Control Groups)

