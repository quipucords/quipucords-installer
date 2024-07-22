Name:           discovery-installer
Summary:        installer for quipucords server

Version:        1.8.1
Release:        1%{?dist}
Epoch:          0

License:        GPLv3
URL:            https://github.com/quipucords/discovery-quadlets
Source0:        %{url}/archive/%{version}.tar.gz

BuildArch:      noarch

Requires:       bash

%description
discovery-installer configures and installs the quipucords server to be
managed and run via systemd using Podman Quadlet services.

%prep
%autosetup -n discovery-quadlets-%{version}

%install
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_datadir}/%{name}/bin
cp bin/%{name} %{buildroot}/%{_bindir}/%{name}
cp bin/create-server-password %{buildroot}/%{_datadir}/%{name}/bin/
cp bin/create-app-secret %{buildroot}/%{_datadir}/%{name}/bin/
mkdir -p %{buildroot}/%{_datadir}/%{name}/config
cp config/*.container config/*.network %{buildroot}/%{_datadir}/%{name}/config/
mkdir -p %{buildroot}/%{_datadir}/%{name}/env
cp env/*.env %{buildroot}/%{_datadir}/%{name}/env/

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
* Mon Jul 22 2024 Brad Smith <brasmith@redhat.com> - 0:1.8.1-1
- Clean up typos in spec file.

* Thu Jun 6 2024 Alberto Bellotti <abellott@redhat.com> - 0:1.8.0-1
- Initial version
