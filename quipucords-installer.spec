%global stream_name quipucords
%global ver 0.1.2
####
%global src_name %{stream_name}-installer
%global egg_name %{stream_name}_installer
Name: %{src_name}
Version: %{ver}
Release: 1%{?dist}
Summary: A tool for discovery and inspection of an IT environment. The %{src_name} provides a server base infrastructure to process tasks that discover and inspect remote systems.

Group: Applications/Internet
License: GNU
URL: http://github.com/quipucords/quipucords
Source0: %{src_name}-%{version}.tar.gz

BuildArch: noarch

BuildRequires: python3-devel
BuildRequires: python3-setuptools
%if "%{stream_name}" == "discovery"
Requires: ansible
Requires: podman
Requires: python3-requests
%endif

%description
A tool for discovery and inspection of an IT environment. The %{src_name} provides a server base infrastructure to process tasks that discover and inspect remote systems.

%prep
%setup -q

%build
%{__python3} setup.py build

%install
%{__python3} setup.py install --skip-build --root %{buildroot}
find %{buildroot}%{python3_sitelib} \
     -name '*.py' \
     -exec sed -i -e '1{/^#!/d}' {} \;

%files
%defattr(-,root,root,-)
%doc README.md AUTHORS.md
%license LICENSE
%{python3_sitelib}/%{egg_name}-%{version}-py3.?.egg-info/
%if "%{stream_name}" == "discovery"
%{python3_sitelib}/%{src_name}/
%else
%{python3_sitelib}/install
%endif

%changelog
* Thu Jun 27 2019 Cody Myers <cmyers@redhat.com> 0.9.0
- Creating the installer as a spec
