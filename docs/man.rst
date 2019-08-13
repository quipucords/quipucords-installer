quipucords-installer
====================

Name
----

quipucords-installer - Installs the quipucords server and qpc cli


Synopsis
--------

``quipiucords-installer [options]``

Description
-----------
The ``quipucords-installer`` tool is used to install the quipucords server and qpc client. The quipucords-installer can be ran by itself to perform a basic install with the preset defaults described in the ``Keys`` section. The most common adaptations of the basic installation are the *Installing Offline*, *Installing a Specific Version*, and *Installing the CLI & Server Separately* which are described below.


Usage
-----

To start the quipucords installation:

  ``quipucords-installer``

Options
-------

Additionally you can pass a flag to obtain the command usage.

**quipucords-installer (-h | --help)**

Optional flags can be set to control ``extra-vars`` options passed to the ansible playbook.

**quipucords-installer (-e | --extra-vars) option=** *value*

**Extra Vars Options**

``-e install_server=false``

  Contains a true or false value. Defaults to ``true``. Supply false to skip the installation of the server.

``-e install_cli=false``

  Contains a true or false value. Defaults to ``true``. Supply false to skip the installation of the command line tool.

``-e install_offline=true``

  Contains a true or false value. Defaults to ``false``. Supply true to start an offline installation.

``-e server_version=0.9.0``

  Contains the semantic versioning format (x.y.z) of the quipucords server you want installed. Required if ``install_offline=true`` and ``install_server=true``.

``-e cli_vesion=0.9.0``

  Contains the semantic versioning format (x.y.z) of the qpc cli you want installed. Required if ``install_offline=true`` and ``install_cli=true``.

``-e open_port=false``

  Contains a true or false value. Defaults to ``true``. Supply false to install without opening the server port in the firewall. The installation script must run with elevated privileges to open the server port.

``-e server_port=8443``

  Contains the port number for the Quipucords server. Defaults to ``9443``.

``-e  dbms_user=postgres``

  Specifies the database user for postgres. Defaults to ``postgres``.

``-e dbms_password``

  Specifies the database password for postgres. Defaults to ``password``.

``-e server_username=cody``

  Quipucords server username. Defaults to ``admin``.

``-e server_password=c0dy``

  Quipucords server password. Defaults to ``qpcpassw0rd``.

``-e server_user_email=cody@hotmail.com``

  Quipucords server user email. Defaults to ``admin@example.com``.

Installing Offline
------------------
If you choose the offline option to run the installer, you will need to obtain the following packages on a machine with internet connectivity.

Packages
~~~~~~~~

*Quipucords Server*

- Required Name: ``quipucords_server_image.tar.gz``
- Location: https://github.com/quipucords/quipucords/releases

*Postgres*

- Required Name: ``postgres.9.6.10.tar``
- The postgres image tar can be created with docker:

``docker pull postgres:9.6.10 && docker save -o postgres.9.6.10.tar postgres:9.6.10``

*QPC CLI*

- Required Name for Centos 6 & RHEL 6: ``qpc.el6.noarch.rpm``
- Required Name for Centos 7 & RHEL 7: ``qpc.el7.noarch.rpm``
- Location: https://github.com/quipucords/qpc/releases

Package Location:
~~~~~~~~~~~~~~~~~

A packages directory will need to be created under one of the following paths depending on your system.

``mkdir -p /usr/{lib}/quipucords-installer-{x.y.z}/install/packages``

- ``{lib}`` is your library version either lib or lib64
- ``{x.y.z}`` is the version of your installer

The packages above will then need to be moved to this directory so that the installer can find them.

``mv path/to/quipucords_server_image.tar.gz /usr/{lib}/quipucords-installer-{x.y.z}/install/packages``

Running the Offline Installation:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
As an example the following command with install version 0.9.0 of the Quipucords server and CLI without internet connectivity:

``quipucords-installer -e install_offline=true -e server_version=0.9.0  -e cli_vesion=0.9.0``

Installing a Specific Version
-----------------------------
The default install will always install the latest release; however, you may choose to install an older version of the quipucords server or the qpc cli.

``quipucords-installer -e server_version=0.9.0  -e cli_vesion=0.9.0``

Installing the CLI & Server Separately
--------------------------------------
The default installation will install the quipucords server and the qpc cli at the same time. However, you may choose to install the cli and server on seperate machines.

Installing the Server without the CLI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The following example command will install the Quipucords server but will not install the CLI.

``quipucords-installer -e install_cli=false``

Installing the CLI without the Server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The following example command will install the QPC CLI but will not install the Quipucords Server.

``quipucords-installer -e install server=false``

Authors
-------

The Quipucords Installer was originally written by Chris Hambridge <chambrid@redhat.com>, Kevan Holdaway <kholdawa@redhat.com>, Ashley Aiken <aaiken@redhat.com>, Cody Myers <cmyers@redhat.com>, and Dostonbek Toirov <dtoirov@redhat.com>.

Copyright
---------

Copyright 2018-2019 Red Hat, Inc. Licensed under the GNU Public License version 3.