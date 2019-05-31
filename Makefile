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
	mkdir -p test/rhel6/install/
	mkdir -p test/rhel7/install/
	mkdir -p test/centos6/install/
	mkdir -p test/centos7/install/

# Internal subcommands that the user should not call
copy-config:
	mkdir -p test/helpers | true
	tar -xvf installer_config.tar.gz | true
	cp -rf installer_config/* test/helpers | true
	rm -rf installer_config/ | true
	cp -rf test/helpers/* test/rhel6 | true
	cp -rf test/helpers/* test/rhel7 | true
	cp -rf test/helpers/* test/centos6 | true
	cp -rf test/helpers/* test/centos7 | true
	rm -rf test/helpers | true

# Internal subcommands that the user should not call
copy-packages:
	cp -rf test/packages/ test/rhel6/install/packages/
	cp -rf test/packages/ test/rhel7/install/packages/
	cp -rf test/packages/ test/centos6/install/packages/
	cp -rf test/packages/ test/centos7/install/packages/

# Internal subcommands that the user should not call
copy-install:
	cp -rf install test/rhel6
	cp -rf install test/rhel7
	cp -rf install test/centos6
	cp -rf install test/centos7

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

setup: create-test-dirs copy-config copy-install copy-packages
setup-release: create-test-dirs copy-config
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
