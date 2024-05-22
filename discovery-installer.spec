Name:           discovery-installer
Version:        1.7
Release:        1%{?dist}
Summary:        Discovery Application v1.7 Installer

License:        GPLv3
URL:            https://gihub.com/quipucords/discovery-quadlets
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       bash

%description
This RPM installs the Discovery Application v1.7 Installer on the System.
The Installer installs and configures Discovery v1.7 to be managed
and run via systemd quadlet services.

%prep
%autosetup -n %{name}-%{version}

%install
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_datadir}/%{name}/bin
cp bin/%{name} %{buildroot}/%{_bindir}/%{name}
cp bin/create-server-password %{buildroot}/%{_datadir}/%{name}/bin/
cp bin/create-app-secret %{buildroot}/%{_datadir}/%{name}/bin/
mkdir -p %{buildroot}/%{_datadir}/%{name}/config
cp config/*.container config/*.network %{buildroot}/%{_datadir}/%{name}/config/
mkdir -p %{buildroot}/%{_datadir}/%{name}/env
cp config/*.env %{buildroot}/%{_datadir}/%{name}/env/

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}
%{_datadir}/%{name}/bin/create-server-password
%{_datadir}/%{name}/bin/create-app-secret
%{_datadir}/%{name}/config/discovery.network
%{_datadir}/%{name}/config/discovery-app.container
%{_datadir}/%{name}/config/discovery-celery-worker.container
%{_datadir}/%{name}/config/discovery-db.container
%{_datadir}/%{name}/config/discovery-redis.container
%{_datadir}/%{name}/config/discovery-server.container
%{_datadir}/%{name}/env/env-ansible.env
%{_datadir}/%{name}/env/env-app.env
%{_datadir}/%{name}/env/env-celery-worker.env
%{_datadir}/%{name}/env/env-db.env
%{_datadir}/%{name}/env/env-redis.env
%{_datadir}/%{name}/env/env-server.env

%changelog
* Sat May 04 2024 Alberto Bellotti <abellott@redhat.com>
1.7
