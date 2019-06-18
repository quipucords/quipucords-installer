DATE = $(shell date)
TOPDIR = $(shell pwd)

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  setup-local-online "
	@echo "         server_source=<local||release> \\"
	@echo "         cli_version=<x.x.x> \\"
	@echo "         server_version=<x.x.x>                  Copy configuration, install, packages to OS specific folders"
	@echo "  setup-local-offline \\"
	@echo "         server_source=<local||release> \\"
	@echo "         cli_version=<x.x.x> \\"
	@echo "         server_version=<x.x.x>                  Download/Build qpc server and postgres images. Download qpc rpm. Copy configuration, install, packages to OS specific folders"
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
	mkdir -p test/rhel6/config/rhel6
	mkdir -p test/rhel7/config/rhel6
	mkdir -p test/centos6/config/rhel6
	mkdir -p test/centos7/config/rhel6
	mkdir -p test/rhel6/config/rhel7
	mkdir -p test/rhel7/config/rhel7
	mkdir -p test/centos6/config/rhel7
	mkdir -p test/centos7/config/rhel7
	mkdir -p test/rhel6/scripts/
	mkdir -p test/rhel7/scripts/
	mkdir -p test/centos6/scripts/
	mkdir -p test/centos7/scripts/

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

copy-vm-helper-files:
	cp -rf vm_helper_files/ test/centos6
	cp -rf vm_helper_files/ test/centos7
	cp -rf vm_helper_files/ test/rhel6
	cp -rf vm_helper_files/ test/rhel7

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

# Internal subcommands that the user should not call
local-server-docker:
	@echo "Building quipucords $(server_version)"
	cd ../quipucords;make build-ui
	cd ../quipucords;docker -D build . -t quipucords:$(server_version)
	cd ../quipucords;docker save -o quipucords_server_image.tar quipucords:$(server_version)
	cd ../quipucords;gzip -f quipucords_server_image.tar
	mkdir -p test/packages
	mv ../quipucords/quipucords_server_image.tar.gz test/packages/

# Internal subcommands that the user should not call
release-server-docker:
	@echo "Downloading quipucords $(server_version)"
	mkdir -p test/packages
ifeq ($(server_version),latest)
	cd test/packages; wget https://github.com/quipucords/quipucords/releases/$(server_version)/download/quipucords_server_image.tar.gz
else
	cd test/packages; wget https://github.com/quipucords/quipucords/releases/download/$(server_version)/quipucords_server_image.tar.gz
endif

setup-local-online: create-test-dirs copy-install copy-vm-helper-files 

setup-local-offline: create-test-dirs copy-install copy-vm-helper-files
ifeq ($(server_source),local)
	$(MAKE) local-server-docker;
else
ifeq ($(server_source),release)
	$(MAKE) release-server-docker;
else
	@echo "Quipucords server source not defined.";
endif
endif
	# Postgres 
	docker pull postgres:9.6.10
	cd test/packages;docker save -o postgres.9.6.10.tar postgres:9.6.10
	$(MAKE) copy-packages
	# CLI Client
	cd test/packages/; curl -k -O -sSL https://github.com/quipucords/qpc/releases/$(cli_version)/download/qpc.el6.noarch.rpm
	cp -f test/packages/qpc.el6.noarch.rpm test/rhel6/install/packages/
	cp -f test/packages/qpc.el6.noarch.rpm test/centos6/install/packages/
	cd test/packages/; curl -k -O -sSL https://github.com/quipucords/qpc/releases/$(cli_version)/download/qpc.el7.noarch.rpm
	cp -f test/packages/qpc.el7.noarch.rpm test/centos7/install/packages/
	cp -f test/packages/qpc.el7.noarch.rpm test/rhel7/install/packages/
	rm -rf test/packages

setup-release: create-test-dirs copy-vm-helper-files copy-config
	mkdir -p test/downloaded_install
	cd test/downloaded_install;curl -k -O -sSL https://github.com/quipucords/quipucords-installer/releases/latest/download/quipucords_install.tar.gz
	cd test/downloaded_install;tar -xzf quipucords_install.tar.gz
	cp -rf test/downloaded_install/install test/rhel6
	cp -rf test/downloaded_install/install test/rhel7
	cp -rf test/downloaded_install/install test/centos6
	cp -rf test/downloaded_install/install test/centos7
	rm -rf test/downloaded_install

refresh: create-test-dirs copy-vm-helper-files copy-config copy-install copy-packages

test-all: refresh
	./launch_vms.sh

test-rhel-6: refresh
	vagrant up vrhel6;vagrant ssh vrhel6

test-rhel-7: refresh
	vagrant up vrhel7;vagrant ssh vrhel7

test-centos-6: refresh
	vagrant up vcentos6;vagrant ssh vcentos6

test-centos-7: refresh
	vagrant up vcentos7;vagrant ssh vcentos7

clean:
	vagrant destroy -f
	rm -rf test
