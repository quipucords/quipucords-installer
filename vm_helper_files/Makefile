DATE = $(shell date)
TOPDIR = $(shell pwd)

.PHONY: install

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  install-help                                       Runs install.sh help"
	@echo "  setup                                              Configure yum repos as needed"
	@echo "  offline-install-prep                               Install required dependencies for offline install"
	@echo "  install                                            Install with defaults"
	@echo "  install-offline                                    Perform an offline installation"
	@echo "           server_version=<x.x.x>                        @param - required"
	@echo "           cli_version=<x.x.x>                           @param - required"
	@echo "  install-version                                    Install a specific version of the server and the client"
	@echo "           server_version=<x.x.x>                        @param - required"
	@echo "           cli_version=<x.x.x>                           @param - required"
	@echo "  clean                                              Remove docker containers and images.  Also, qpc cli."


install-help:
	./install/install.sh --help

setup:
	scripts/setup_repos.sh

offline-install-prep: setup
	@if grep -q -i "release 7" /etc/redhat-release; then \
		echo "Running 7"; \
		yum install -y libcgroup; \
		yum install -y yum-utils; \
		yum install -y ansible; \
		yum install -y docker; \
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
		subscription-manager repos --enable="rcm-tools-rhel-8-baseos-rpms" || true; \
		subscription-manager repos --enable="rcm-tools-rhel-8-appstream-rpms" || true; \
		subscription-manager repos --enable ansible-2.8-for-rhel-8-x86_64-rpms; \
		yum install -y ansible; \
		yum install -y podman; \
		yum install -y python36; \
		yum install -y python3-requests; \
	fi

install: setup
	cd install;./install.sh

install-offline:
	cd install;./install.sh -e install_offline=true -e server_version=$(server_version) -e cli_version=$(cli_version)

install-version: setup
	cd install;./install.sh -e server_version=$(server_version) -e cli_version=$(cli_version)

clean:
	scripts/cleanup.sh
