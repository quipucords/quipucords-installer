%global product_name_lower quipucords
%global product_name_title Quipucords
%global version_installer 2.2.0
%global server_image quay.io/quipucords/quipucords:2.2
%global ui_image quay.io/quipucords/quipucords-ui:2.2

Name:           %{product_name_lower}-installer
Summary:        installer for %{product_name_lower} server

Version:        %{version_installer}
Release:        1%{?dist}
Epoch:          0

License:        GPLv3
URL:            https://github.com/quipucords/quipucords-installer
Source0:        %{url}/archive/%{version}.tar.gz

BuildArch:      noarch

BuildRequires:  coreutils
BuildRequires:  sed

Requires:       bash
Requires:       coreutils
Requires:       diffutils
Requires:       gawk
Requires:       grep
Requires:       podman >= 4.9.4
Requires:       sed

%description
%{name} configures and installs the %{product_name_title} server to be
managed and run via systemd using Podman Quadlet services.

%prep
# Note: this must match the GitHub repo name. Do not substitute variables.
%autosetup -n quipucords-installer-%{version}

%install
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_datadir}/%{name}/bin
cp bin/quipucords-installer %{buildroot}/%{_bindir}/%{name}
cp bin/create-server-password %{buildroot}/%{_datadir}/%{name}/bin/
cp bin/create-redis-password %{buildroot}/%{_datadir}/%{name}/bin/
cp bin/create-db-password %{buildroot}/%{_datadir}/%{name}/bin/
cp bin/create-app-secret %{buildroot}/%{_datadir}/%{name}/bin/

mkdir -p %{buildroot}/%{_datadir}/%{name}/env
cp env/*.env %{buildroot}/%{_datadir}/%{name}/env/

# Copy and rename original source files with appropriate branding.
mkdir -p %{buildroot}/%{_datadir}/%{name}/config
cp config/quipucords-app.container %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-app.container
cp config/quipucords-celery-worker.container %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-celery-worker.container
cp config/quipucords-db.container %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-db.container
cp config/quipucords-redis.container %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-redis.container
cp config/quipucords-server.container %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-server.container
cp config/quipucords.network %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}.network

# Update source files contents with appropriate branding.
sed -i 's/Quipucords/%{product_name_title}/g;s/quipucords/%{product_name_lower}/g' %{buildroot}/%{_bindir}/%{name}
sed -i 's/Quipucords/%{product_name_title}/g;s/quipucords/%{product_name_lower}/g' %{buildroot}/%{_datadir}/%{name}/bin/*
sed -i 's/Quipucords/%{product_name_title}/g;s/quipucords/%{product_name_lower}/g' %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}*
sed -i 's/Quipucords/%{product_name_title}/g;s/quipucords/%{product_name_lower}/g' %{buildroot}/%{_datadir}/%{name}/env/*

# Inject specific image versions into the container files.
sed -i 's#^Image=.*#Image=%{server_image}#g' %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-server.container
sed -i 's#^Image=.*#Image=%{server_image}#g' %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-celery-worker.container
sed -i 's#^Image=.*#Image=%{ui_image}#g' %{buildroot}/%{_datadir}/%{name}/config/%{product_name_lower}-app.container

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}
%{_datadir}/%{name}/bin/create-server-password
%{_datadir}/%{name}/bin/create-redis-password
%{_datadir}/%{name}/bin/create-db-password
%{_datadir}/%{name}/bin/create-app-secret
%{_datadir}/%{name}/config/%{product_name_lower}.network
%{_datadir}/%{name}/config/%{product_name_lower}-app.container
%{_datadir}/%{name}/config/%{product_name_lower}-celery-worker.container
%{_datadir}/%{name}/config/%{product_name_lower}-db.container
%{_datadir}/%{name}/config/%{product_name_lower}-redis.container
%{_datadir}/%{name}/config/%{product_name_lower}-server.container
%{_datadir}/%{name}/env/env-ansible.env
%{_datadir}/%{name}/env/env-app.env
%{_datadir}/%{name}/env/env-celery-worker.env
%{_datadir}/%{name}/env/env-db.env
%{_datadir}/%{name}/env/env-redis.env
%{_datadir}/%{name}/env/env-server.env

%changelog
* Wed Aug 28 2024 Brad Smith <brasmith@redhat.com> - 0:1.10.0-1
- Rename environment variables prefix "QPC_" to "QUIPUCORDS_".

* Thu Aug 15 2024 Brad Smith <brasmith@redhat.com> - 0:1.9.3-1
- Add upgrade command.

* Thu Aug 1 2024 Brad Smith <brasmith@redhat.com> - 0:1.9.2-1
- Add missing BuildRequires and Requires.

* Mon Jul 22 2024 Brad Smith <brasmith@redhat.com> - 0:1.8.1-1
- Update names and fix typos in spec file.

* Thu Jun 6 2024 Alberto Bellotti <abellott@redhat.com> - 0:1.8.0-1
- Initial version
