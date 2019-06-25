DATE = $(shell date)
TOPDIR = $(shell pwd)

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  setup                                          Copy configuration, install, packages to OS specific folders"
	@echo "  setup-release                                  Download latest official install scripts from GitHub.  Copy configuration, install, packages to OS specific folders"
	@echo "  refresh                                        Recopy configuration, install, packages to OS specific folders"
	@echo "  build-docker version=<release_version>         Build a docker image for quipucords source"
	@echo "  test-all                                       Launch VMs for all supported Operating Systems"
	@echo "  test-rhel-6                                    Launch the RHEL 6 VM for testing"
	@echo "  test-rhel-7                                    Launch the RHEL 7 VM for testing"
	@echo "  test-centos-6                                  Launch the CentOS 6 VM for testing"
	@echo "  test-centos-7                                  Launch the CentOS 7 VM for testing"
	@echo "  clean                                          Cleanup configure files and destroy VMs"

# Internal subcommands that the user should not call
create-test-dirs:
	mkdir -p test/packages
	@for os in rhel6 rhel7 centos6 centos7; do \
		set -x; \
		mkdir -p test/$$os/install/; \
		mkdir -p test/$$os/config/rhel6; \
		mkdir -p test/$$os/config/rhel7; \
		mkdir -p test/$$os/scripts/; \
		set +x; \
	done

copy-vm-helper-files:
	for os in rhel6 rhel7 centos6 centos7 ; do cp -vrf vm_helper_files/ test/$$os; done

# Internal subcommands that the user should not call
copy-config:
	@if [ -e installer_config.tar.gz ]; then \
		mkdir -p test/helpers | true; \
		tar -xvf installer_config.tar.gz | true; \
		cp -rf installer_config/* test/helpers | true; \
		rm -rf installer_config/ | true; \
		for dest in test/rhel7 test/rhel6 test/centos6 test/centos7 ; do cp -vrf test/helpers/* $$dest | true; done; \
		rm -rf test/helpers | true; \
	else \
		echo "installer_config.tar.gz does not exist"; \
	fi

# Internal subcommands that the user should not call
copy-packages:
	for os in rhel6 rhel7 centos6 centos7 ; do cp -vrf test/packages/ test/$$os/install/packages/ ; done

# Internal subcommands that the user should not call
copy-install:
	for os in rhel6 rhel7 centos6 centos7 ; do cp -vrf install test/$$os; done

build-docker:
	echo "Building quipucords $(version)"
	cd ../quipucords;make build-ui
	cd ../quipucords;docker -D build . -t quipucords:$(version)
	cd ../quipucords;docker save -o quipucords_server_image.tar quipucords:$(version)
	cd ../quipucords;gzip -f quipucords_server_image.tar
	mkdir -p test/packages
	mv ../quipucords/quipucords_server_image.tar.gz test/packages/
	docker pull postgres:9.6.10
	cd test/packages;docker save -o postgres.9.6.10.tar postgres:9.6.10

setup: create-test-dirs copy-vm-helper-files copy-config copy-install copy-packages
setup-release: create-test-dirs copy-vm-helper-files copy-config
	mkdir -p test/downloaded_install
	cd test/downloaded_install;curl -k -O -sSL https://github.com/quipucords/quipucords-installer/releases/latest/download/quipucords_install.tar.gz
	cd test/downloaded_install;tar -xzf quipucords_install.tar.gz
	cp -rf test/downloaded_install/install test/rhel6
	cp -rf test/downloaded_install/install test/rhel7
	cp -rf test/downloaded_install/install test/centos6
	cp -rf test/downloaded_install/install test/centos7
	rm -rf test/downloaded_install

refresh: setup

test-all: setup
	./launch_vms.sh

test-rhel-6: setup
	vagrant up vrhel6;vagrant ssh vrhel6

test-rhel-7: setup
	vagrant up vrhel7;vagrant ssh vrhel7

test-centos-6: setup
	vagrant up vcentos6;vagrant ssh vcentos6

test-centos-7: setup
	vagrant up vcentos7;vagrant ssh vcentos7

clean:
	vagrant destroy -f
	rm -rf test
