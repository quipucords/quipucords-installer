DATE = $(shell date)
TOPDIR = $(shell pwd)

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  setup-local-online                             Copy configuration, install, packages to OS specific folders"
	@echo "  setup-local-offline                            Download/Build qpc server and postgres images. Download qpc client rpm. Copy configuration, install, packages to OS specific folders"
	@echo "         server_source=<local||release>                @param - defaults to release"
	@echo "         cli_version=<x.x.x>                           @param - defaults to latest"
	@echo "         server_version=<x.x.x>                        @param - required if server source is local; defaults to latest if using release"
	@echo "  setup-release                                  Download latest official install scripts from GitHub.  Copy configuration, install, packages to OS specific folders"
	@echo "  refresh                                        Recopy configuration, install, packages to OS specific folders"
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
		set -x; \
		mkdir -p test/helpers | true; \
		tar -xvf installer_config.tar.gz | true; \
		cp -rf installer_config/* test/helpers | true; \
		rm -rf installer_config/ | true; \
		for dest in test/rhel7 test/rhel6 test/centos6 test/centos7 ; do cp -vrf test/helpers/* $$dest | true; done; \
		rm -rf test/helpers | true; \
		set +x; \
	else \
		echo "installer_config.tar.gz does not exist"; \
	fi

# Internal subcommands that the user should not call
copy-packages:
	for os in rhel6 rhel7 centos6 centos7 ; do cp -vrf test/packages/ test/$$os/install/packages/ ; done

# Internal subcommands that the user should not call
copy-install:
	for os in rhel6 rhel7 centos6 centos7 ; do cp -vrf install test/$$os; done

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
	mkdir -p test/packages
ifeq ($(server_version),$(filter $(server_version),latest))
	@echo "Downloading quipucords latest"
	cd test/packages; wget https://github.com/quipucords/quipucords/releases/latest/download/quipucords_server_image.tar.gz -O quipucords_server_image.tar.gz
else
	@echo "Downloading quipucords $(server_version)"
	cd test/packages; wget https://github.com/quipucords/quipucords/releases/download/$(server_version)/quipucords_server_image.tar.gz -O quipucords_server_image.tar.gz
endif

# Internal subcommands that the user should not call
download-client:
	@for os_version in 6 7 ; do \
		set -x; \
		if [[ "$(cli_version)" = "" || "$(cli_version)" = "latest" ]]; then \
			curl -k -sSL https://github.com/quipucords/qpc/releases/latest/download/qpc.el$$os_version.noarch.rpm -o test/packages/qpc.el$$os_version.noarch.rpm; \
		else \
			curl -k -sSL https://github.com/quipucords/qpc/releases/download/$(cli_version)/qpc.el$$os_version.noarch.rpm -o test/packages/qpc.el$$os_version.noarch.rpm; \
		fi; \
		cp -f test/packages/qpc.el$$os_version.noarch.rpm test/rhel$$os_version/install/packages/; \
		cp -f test/packages/qpc.el$$os_version.noarch.rpm test/centos$$os_version/install/packages/; \
		set +x; \
	done
	rm -f test/packages/*.noarch.rpm

setup-local-online: create-test-dirs copy-install copy-vm-helper-files copy-config

setup-local-offline: create-test-dirs copy-install copy-vm-helper-files copy-config
ifeq ($(server_source),local)
ifeq ($(server_version),)
	@echo "Server version is not provided. Exiting...";
	@exit 1;
else
	$(MAKE) local-server-docker;
endif
else
ifeq ($(server_source),release)
	$(MAKE) release-server-docker;
else
	@echo "Quipucords server source not defined.";
	@echo "Setting release as default server source.";
	$(MAKE) release-server-docker;
endif
endif
	docker pull postgres:9.6.10
	cd test/packages;docker save -o postgres.9.6.10.tar postgres:9.6.10
	$(MAKE) copy-packages
	$(MAKE) download-client

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
