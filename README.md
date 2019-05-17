# Quipucords Installer

Installs the Quipucords server and CLI.  Quipucords is a tool for discovery, inspection, collection, deduplication, and reporting on an IT environment.

This *README* file contains information about the installation and development of quipucords, as well as instructions about where to find basic usage, known issues, and best practices information.

- [Introduction to quipucords installer](#intro)
- [Requirements and Assumptions](#requirements)
- [Installation](#installation)
- [Development](#development)
- [Issues](#issues)
- [Authors](#authors)
- [Copyright and License](#copyright)


## <a name="intro"></a> Introduction to Quipucords installer
Quipucords installer is a bash script that utilizes Ansible to install both the Quipucords server and CLI.


## <a name="requirements"></a> Requirements and Assumptions
Before installing quipucords on a system, review the following guidelines about installing and running quipucords:

 - quipucords installer is written to run on RHEL or Centos servers.
 
## <a name="installation"></a> Installation
To work with the quipucords installer, begin by cloning the repository.

```
git clone git@github.com:quipucords/quipucords-installer.git
cd quipucords-installer
./install.sh
```

## <a name="development"></a> Development
To develop the quipucords installer, begin by cloning the repository.
```
git clone git@github.com:quipucords/quipucords-installer.git
```
## <a name="issue"></a> Issues
To report bugs for quipucords installer [open issues](https://github.com/quipucords/quipucords-installer/issues) against this repository in Github. Complete the issue template when opening a new bug to improve investigation and resolution time.


## <a name="authors"></a> Authors
Authorship and current maintainer information can be found in [AUTHORS](AUTHORS.md)


## <a name="copyright"></a> Copyright and License
Copyright 2019, Red Hat, Inc.

quipucords is released under the [GNU Public License version 3](LICENSE)
