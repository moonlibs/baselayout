%define __autobuild__ 0

%define __distribution APPNAME
%define __summary "My great tarantool app"

%define __repo    yestree
%define __git     git@gitlab.corp.mail.ru:cloud/%{__repo}
%define __dir     %{__distribution}

%define version 0.01

%define release %(/bin/date +"%Y.%m%d.%H%M")
%define packagename %{__distribution}

%define app_dir /opt/%{__distribution}

Name:           %{__distribution}
Version:        %{version}
Release:        %{release}
Summary:        %{__summary}

Group:          tarantool/db
License:        proprietary

%if %{__autobuild__}
Packager: BUILD_USER
Source0: %{__repo}-GIT_TAG.tar.bz2
%else
%if %{?SRC_DIR:0}%{!?SRC_DIR:1}
Source0: %{__repo}.tar.bz2
%endif
%endif

Requires: tarantool >= 1.9.0.50
BuildRequires: git
BuildRequires: tarantool >= 1.9.0
BuildRequires: tarantool-devel >= 1.9.0
BuildRequires: lua-devel > 5.1
BuildRequires: lua-devel < 5.2
BuildRequires: luarocks

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description
%{__summary}

%prep
%if %{?SRC_DIR:1}%{!?SRC_DIR:0}
    rm -rf %{__repo}
    cp -ravi %{SRC_DIR} %{__repo}
    cd %{__repo}
%else
%setup -q -n %{__repo}
%endif

%build
%if %{?SRC_DIR:1}%{!?SRC_DIR:0}
    cd %{__repo}
%endif
cd %{__dir}
make test

mkdir -p ./%{name}-%{version}-%{release}-libs
tarantool dep.lua --meta-file ./meta.yaml --luarocks-tree ./%{name}-%{version}-%{release}-libs

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}
%if %{?SRC_DIR:1}%{!?SRC_DIR:0}
    cd %{__repo}
%endif
cd %{__dir}
install -d -m 0755 %{buildroot}/usr/share/%{packagename}  # for init.lua, app and libs

install -m 0644 ./init.lua                  %{buildroot}/usr/share/%{packagename}/
cp -aR ./app                                %{buildroot}/usr/share/%{packagename}/
cp -aR ./%{name}-%{version}-%{release}-libs %{buildroot}/usr/share/%{packagename}/libs

install -d -m 0755 %{buildroot}/etc/%{packagename}  # for conf.lua
install -m 0644 ./etc/conf.inst.lua         %{buildroot}/etc/%{packagename}/conf.lua

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root)
%dir /usr/share/%{packagename}
%dir /etc/%{packagename}
/usr/share/%{packagename}/init.lua
/usr/share/%{packagename}/app
/usr/share/%{packagename}/libs

%config(noreplace) /etc/%{packagename}/conf.lua

%changelog
