# Quipucords Installer

Installs the Quipucords server and CLI.  Quipucords is a tool for discovery, inspection, collection, deduplication, and reporting on an IT environment.

This *README* file contains information about the installation and development of Quipucords installer, as well as instructions about where to find basic usage, known issues, and best practices information.

- [Introduction to Quipucords installer](#intro)
- [Requirements and Assumptions](#requirements)
- [Installation](#installation)
- [Development](#development)
- [Test](#test)
- [Issues](#issues)
- [Authors](#authors)
- [Copyright and License](#copyright)


# <a name="intro"></a> Introduction to Quipucords installer
Quipucords installer is a bash script that utilizes Ansible to install both the Quipucords server and CLI.


# <a name="requirements"></a> Requirements and Assumptions
Before installing Quipucords installer on a system, review the following guidelines about installing and running Quipucords and Quipucords installer:

 - Quipucords installer is written to run on RHEL or Centos servers.

# <a name="installation"></a> Installation
To work with the Quipucords installer, begin by cloning the repository.

```
git clone git@github.com:quipucords/quipucords-installer.git
cd quipucords-installer/install
./install.sh
```

# <a name="development"></a> Development
To develop the Quipucords installer, begin by cloning the repository.
```
git clone git@github.com:quipucords/quipucords-installer.git
```
# <a name="test"></a> Test
There are various options for testing your changes to the installation scripts.  You can test scripts from this repository or an official build.  First you need to launch the VMs configured with the installation files and docker images you wish to test.
## Configuring the Virtual Machines
First bring up the virtual machines using one of the methods below.

### Method 1: Testing local changes using a docker image build from source.
First obtain all the required repositories.
```
git clone git@github.com:quipucords/quipucords.git
git clone git@github.com:quipucords/quipucords-ui.git
git clone git@github.com:quipucords/quipucords-installer.git
```
Build the docker image and test with the local install scripts on all supported OS's run the following.
```
make build-docker version=0.0.46
make setup
make test-all
```

If you make changes to the installation scripts and want to test them you can run:
```
make refresh
```
There is no need to restart the VM.


### Method 2: Testing local changes using release docker image
First obtain all the required repositories.
```
git clone git@github.com:quipucords/quipucords-installer.git
```

To test your local scripts on all supported OS's run the following.
```
make setup
make test-all
```

If you make changes to the installation scripts and want to test them you can run:
```
make refresh
```
There is no need to restart the VM.

### Method 3: Testing official release
First obtain all the required repositories.
```
git clone git@github.com:quipucords/quipucords-installer.git
```

To test your local scripts on all supported OS's run the following.
```
make setup-release version=0.0.46
make test-all
```

_Note_: 0.0.46 can be replaced by the version number you wish to test.

## Installing QPC Inside the Virtual Machine
The above `test-all` command will perform a  `vagrant ssh`.  If you have no configuration help, then you can simply run `install.sh`.

### Configuration Scripts (internal)
Create or obtain a tarball named `installer_config.tar.gz`.  The files in this tarball will automatically be copied inside the VMs mapped volumes.

To configure use our internal scripts, do the following:
1. `cd /quipucords_installer;sudo su`
2. `make setup`
3. `make install`
4. `make add-qpc-data`

This will configure repositories if needed, install the server and CLI, and add sample QPC artifacts.

# <a name="issues"></a> Issues
To report bugs for Quipucords installer [open issues](https://github.com/quipucords/quipucords-installer/issues) against this repository in Github. Complete the issue template when opening a new bug to improve investigation and resolution time.


# <a name="authors"></a> Authors
Authorship and current maintainer information can be found in [AUTHORS](AUTHORS.md)


# <a name="copyright"></a> Copyright and License
Copyright 2019, Red Hat, Inc.

Quipucords installer is released under the [GNU Public License version 3](LICENSE)
