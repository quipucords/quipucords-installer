DATE = $(shell date)
TOPDIR = $(shell pwd)

.PHONY: install

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  setup                                              Sets up yum repos"
	@echo "  offline-prep                                       Install required dependencies for offline install"
	@echo "  install-help                                       Runs quipucords-installer help"
	@echo "  install                                            Install with defaults"
	@echo "  install-offline                                    Perform an offline installation"
	@echo "           server_version=<x.x.x>                        @param - required"
	@echo "           cli_version=<x.x.x>                           @param - required"
	@echo "  install-version                                    Install a specific version of the server and the client"
	@echo "           server_version=<x.x.x>                        @param - required"
	@echo "           cli_version=<x.x.x>                           @param - required"
	@echo "  clean                                              Remove docker containers and images.  Also, qpc cli."


install-help:
	./install/quipucords-installer --help

setup:
	scripts/setup_repos.sh

offline-prep: setup
	@if grep -q -i "release 7" /etc/redhat-release; then \
		echo "Running 7"; \
		yum install -y libcgroup; \
		yum install -y yum-utils; \
		yum install -y ansible; \
		yum install -y docker; \
		yum install -y podman; \
		yum install -y epel-release; \
		yum install -y python36; \
		yum install -y python36-requests; \
	elif grep -q -i "release 6" /etc/redhat-release; then \
		echo "Running 6"; \
		yum install -y libcgroup; \
		yum install -y yum-utils; \
		yum install -y ansible; \
		yum install -y xz; \
		cd install/packages/; curl -k -O -sSl http://yum.dockerproject.org/repo/main/centos/6/Packages/docker-engine-1.7.1-1.el6.x86_64.rpm; \
		rpm -Uvh --force "docker-engine-1.7.1-1.el6.x86_64.rpm"; \
		yum install -y python34; \
		yum install -y python34-requests; \
	else \
		echo "Running 8"; \
		yum install -y ansible; \
		yum install -y podman; \
		yum install -y python36; \
		yum install -y python3-requests; \
		yum install -y libselinux-python3; \
	fi

#Internal
online-prep: setup
	@if grep -q -i "release 7" /etc/redhat-release; then \
		echo "Running 7"; \
		yum install -y libcgroup; \
		yum install -y yum-utils; \
		yum install -y ansible; \
		yum install -y podman; \
	elif grep -q -i "release 6" /etc/redhat-release; then \
		echo "Running 6"; \
		yum install -y libcgroup; \
		yum install -y yum-utils; \
		yum install -y ansible; \
	else \
		echo "Running 8"; \
		yum install -y ansible; \
		yum install -y podman; \
	fi


install-offline:
	cd install;./quipucords-installer -e install_offline=true -e server_version=$(server_version) -e cli_version=$(cli_version)

install: online-prep
	cd install;./quipucords-installer

install-version: online-prep
	cd install;./quipucords-installer -e server_version=$(server_version) -e cli_version=$(cli_version)

clean:
	scripts/cleanup.sh
