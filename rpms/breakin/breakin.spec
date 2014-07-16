Name:           breakin
Version:        3.2
Release:        8%{?dist}.tumblr
Summary:        stress-test and hardware diagnostics tool

Group:          Applications/System
License:        open source
URL:            http://www.advancedclustering.com/software/breakin.html
Source0:        http://git.advancedclustering.com/git/breakin.git/breakin-%{version}.tar.gz
Source1:        breakin-HPL-top.txt
Source2:        breakin-HPL-middle.txt
Source3:        breakin-HPL-bottom.txt
Source4:        breakin-library.sh
Patch0:		breakin-installprefix.patch
Patch1:		breakin-enterprisify.patch
Patch2:		breakin-new_ash_to_sh.patch
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  curl-devel, ncurses-devel
Requires:       libcurl, ncurses, hddtemp, mcelog, ethtool, smartmontools, hpl

%description
Breakin is Advanced Clustering's stress-test and hardware diagnostics tool. Advanced Clustering engineers developed breakin because no other available product — commercial or open source — could pinpoint hardware issues and component failures as well as they wanted.

The breakin application proved to be so powerful at finding hardware issues that it is now used by several major component manufacturers in their validation and factory testing procedures.


%prep
%setup -q
%patch0 -p1
%patch1 -p1
%patch2 -p1


%build
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -D -m755 ${RPM_SOURCE_DIR}/breakin-library.sh ${RPM_BUILD_ROOT}/etc/breakin/library.sh
install -D -m644 ${RPM_SOURCE_DIR}/breakin-HPL-top.txt ${RPM_BUILD_ROOT}/etc/breakin/HPL-top.txt
install -D -m644 ${RPM_SOURCE_DIR}/breakin-HPL-middle.txt ${RPM_BUILD_ROOT}/etc/breakin/HPL-middle.txt
install -D -m644 ${RPM_SOURCE_DIR}/breakin-HPL-bottom.txt ${RPM_BUILD_ROOT}/etc/breakin/HPL-bottom.txt


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
/etc/breakin/dumplog.sh
/etc/breakin/hardware.sh
/etc/breakin/ipmi.sh
/etc/breakin/startup.sh
/etc/breakin/stop.sh
/etc/breakin/tests/badblocks
/etc/breakin/tests/ecc
/etc/breakin/tests/failid
/etc/breakin/tests/hdhealth
/etc/breakin/tests/hpl
/etc/breakin/tests/mcelog
/etc/breakin/HPL-bottom.txt
/etc/breakin/HPL-middle.txt
/etc/breakin/HPL-top.txt
/etc/breakin/library.sh
/usr/local/bin/breakin
/usr/local/bin/cryptpasswd
/usr/local/bin/hpl_calc_n
%doc



%changelog
* Wed Jul 16 2014 Arnoud Vermeer <a.vermeer@freshway.biz> 3.2-8.tumblr
- new package built with tito

* Thu Jan 19 2012 Joshua Hoffman <joshua@tumblr.com> 3.2-7.tumblr
- new package built with tito

* Thu Jan 19 2012 Joshua Hoffman <joshua@tumblr.com> 3.2-7.tumblr
- new package, now built with tito

* Thu Jan 05 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-6.tumblr
- removed bonnie++ from requirements

* Thu Jan 05 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-5.tumblr
- fixed path to HPL templates

* Thu Jan 05 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-4.tumblr
- cleaned up requirements

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-3.tumblr
- added new_ash_to_sh.patch

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-2.tumblr
- removed ash_to_sh patch, replaced by enterprisify patch

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 3.2-1.tumblr
- extensive patching, added missing HPL template files

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 2.2-5.tumblr
- added missing requirements

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 2.2-4.tumblr
- added acml

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 2.2-3.tumblr
- changed to ash_to_sh patch

* Wed Jan 04 2012 Joshua Hoffman <joshua@tumblr.com> - 2.2-2.tumblr
- added startup_shell patch

* Tue Jan 03 2012 Joshua Hoffman <joshua@tumblr.com> - 2.2-1.tumblr
- initial build

