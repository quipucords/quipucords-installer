DATE = $(shell date)
TOPDIR = $(shell pwd)

.PHONY: install

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  setup                                              Configure yum repos as needed"
	@echo "  offline-install-prep-6                             Install necessary dependencies for offline install (RHEL/Centos 6)"
	@echo "  offline-install-prep-7                             Install necessary dependencies for offline install (RHEL/Centos 7)"
	@echo "  install                                            Install with defaults"
	@echo "  install-offline version=<release_version>          Perform an offline installation"
	@echo "  install-version version=<release_version>          Install a specific version using version parameter"
	@echo "  clean                                              Remove docker containers and images.  Also, qpc cli."


setup:
	scripts/setup_repos.sh

install:
	cd install;./install.sh

install-offline:
	cd install;./install.sh -e install_offline=true -e server_version=$(version) -e cli_version=$(version)

install-version:
	cd install;./install.sh -e server_version=$(version) -e cli_version=$(version)

clean:
	scripts/cleanup.sh

offline-install-prep-6: setup
	cd install/packages/; curl -k -O -sSl http://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm
	cd install/packages/; curl -k -O -sSL https://github.com/quipucords/qpc/releases/latest/download/qpc.el6.noarch.rpm
	yum install -y yum-utils
	yum install -y ansible
	yum install -y python34
	yum install -y python34-requests
	yum install -y libcgroup
	yum install -y xz

offline-install-prep-7: setup
	cd install/packages/; curl -k -O -sSL https://github.com/quipucords/qpc/releases/latest/download/qpc.el7.noarch.rpm
	yum install -y docker
	yum install -y epel-release
	yum install -y yum-utils
	yum install -y ansible
	yum install -y libcgroup
	yum install -y python36
	yum install -y python36-requests
