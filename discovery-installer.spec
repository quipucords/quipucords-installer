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
mkdir -p %{buildroot}/etc/%{name}/bin
cp bin/%{name} %{buildroot}/%{_bindir}/%{name}
cp bin/create-server-password %{buildroot}/etc/%{name}/bin/
cp bin/create-app-secret %{buildroot}/etc/%{name}/bin/
cp bin/open-firewall-port %{buildroot}/etc/%{name}/bin/
mkdir -p %{buildroot}/etc/%{name}/config
cp config/*.container config/*.network %{buildroot}/etc/%{name}/config/
mkdir -p %{buildroot}/etc/%{name}/env
cp config/*.env %{buildroot}/etc/%{name}/env/

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}
/etc/%{name}/bin/create-server-password
/etc/%{name}/bin/create-app-secret
/etc/%{name}/bin/open-firewall-port
/etc/%{name}/config/discovery.network
/etc/%{name}/config/discovery-app.container
/etc/%{name}/config/discovery-celery-worker.container
/etc/%{name}/config/discovery-db.container
/etc/%{name}/config/discovery-redis.container
/etc/%{name}/config/discovery-server.container
/etc/%{name}/env/env-ansible.env
/etc/%{name}/env/env-app.env
/etc/%{name}/env/env-celery-worker.env
/etc/%{name}/env/env-db.env
/etc/%{name}/env/env-redis.env
/etc/%{name}/env/env-server.env

%changelog
* Sat May 04 2024 Alberto Bellotti <abellott@redhat.com>
1.7
