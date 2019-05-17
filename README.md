# Quipucords Installer

Installs the Quipucords server and CLI.  Quipucords is a tool for discovery, inspection, collection, deduplication, and reporting on an IT environment

This *README* file contains information about the installation and development of quipucords, as well as instructions about where to find basic usage, known issues, and best practices information.

-  [Introduction to quipucords installer](#intro)
- [Requirements and Assumptions](#requirements)
- [Installation](#installation)
- [Development](#development)
- [Issues](#issues)
- [Authors](#author)
- [Copyright and License](#copyright)


## Introduction to Quipucords installer<a name="intro"></a>
Quipucords installer is a bash script that utilizes Ansible to install both the Quipucords server and CLI.


## Requirements and Assumptions<a name="requirements"></a>
Before installing quipucords on a system, review the following guidelines about installing and running quipucords:

 - quipucords installer is written to run on RHEL or Centos servers.
 
## Installation<a name="installation"></a>
To work with the quipucords installer, begin by cloning the repository.

```
git clone git@github.com:quipucords/quipucords-installer.git
cd quipucords-installer
./install.sh
```

## Development<a name="development"></a>
To develop the quipucords installer, begin by cloning the repository.
```
git clone git@github.com:quipucords/quipucords-installer.git
```
## Issues<a name="issue"></a>
To report bugs for quipucords installer [open issues](https://github.com/quipucords/quipucords-installer/issues) against this repository in Github. Complete the issue template when opening a new bug to improve investigation and resolution time.


## Authors<a name="authors"></a>
Authorship and current maintainer information can be found in [AUTHORS](AUTHORS.md)


## Copyright and License<a name="copyright"></a>
Copyright 2019, Red Hat, Inc.

quipucords is released under the [GNU Public License version 3](LICENSE)
