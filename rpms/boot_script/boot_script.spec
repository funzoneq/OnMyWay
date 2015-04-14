Name:           boot_script
Version:        1.0.1
Release:        5%{?dist}
Summary:        Reads /proc/cmdline for arguments to use process as scripts
Group:          Systems Administration
License:        Tumblr
URL:            https://github.com/funzoneq/OnMyWay/tree/master/rpms/boot_script
Source0:        boot_script
Source1:        getstarted
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:  chkconfig bash
Requires:       curl bc
BuildArch:	    noarch

%description
This is an init script, it starts on boot and reads /proc/cmdline (arguments passed to the kernel as boot time)
for the following two arguments:
- SCRIPT_URL => which should be a URL to a script.  When set, the value is pulled down, and executed
- SCRIPT_CMD => which should be full path to a script, this value is evaluated as a command

%prep


%build


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/etc/init.d/
mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -D -m 755 %{SOURCE0} $RPM_BUILD_ROOT/etc/init.d/
install -D -m 755 %{SOURCE1} $RPM_BUILD_ROOT/usr/bin/

%clean
rm -rf $RPM_BUILD_ROOT

%post
/sbin/chkconfig boot_script on

%postun

%files
%defattr(-,root,root,-)
%doc
/etc/init.d/boot_script
/usr/bin/getstarted

%changelog
* Tue Apr 14 2015 Arnoud Vermeer <a.vermeer@tech.leaseweb.com> 1.0.1-5
- Update getstarted (a.vermeer@freshway.biz)

* Thu Nov 27 2014 Arnoud Vermeer <a.vermeer@freshway.biz> 1.0.1-4
- Modprobe IPMI (a.vermeer@freshway.biz)

* Mon Jun 02 2014 Arnoud Vermeer <a.vermeer@freshway.biz> 1.0.1-3
- Various fixes. Making PLAYBOOK an option (a.vermeer@freshway.biz)

* Mon Jun 02 2014 Arnoud Vermeer <a.vermeer@freshway.biz> 1.0.1-2
- new package built with tito

* Tue Mar 04 2014 Roy Marantz <marantz@tumblr.com> 1.0.0-9.tumblr
- fix passing of command exit code (for start)
- fix testing of command exit codes
- fix saving of pid for sub-processes
- fix stop to correctly use them and clean them up the files

* Tue Mar 04 2014 Roy Marantz <marantz@tumblr.com>
- fix passing of command exit code (for start)
- fix testing of command exit codes
- fix saving of pid for sub-processes
- fix stop to correctly use them and clean them up the files

* Thu Aug 16 2012 Michael Schenck <michael@tumblr.com> 1.0.0-7.tumblr
- Better return values when either PARAM is left out at boot time
  (michael@tumblr.com)
- Actually running the kernel param command methods (instead of just setting
  their method names to a results value intended to catch their output)
  (michael@tumblr.com)

* Thu Aug 16 2012 Michael Schenck <michael@tumblr.com> 1.0.0-6.tumblr
- this is why i hate the 'cut' command .... (michael@tumblr.com)

* Wed Aug 15 2012 Michael Schenck <michael@tumblr.com> 1.0.0-5.tumblr
- yea ... just an init script ... this is noarch (michael@tumblr.com)

* Wed Aug 15 2012 Michael Schenck <michael@tumblr.com> 1.0.0-4.tumblr
- First, init scripts need to be executable, but this one also requires the
  'bc' command (michael@tumblr.com)

* Wed Aug 08 2012 Michael Schenck <michael@tumblr.com> 1.0.0-3.tumblr
- Added necessary BuildRequires to boot_script (michael@tumblr.com)
- Added (missing) mkdir -p (michael@tumblr.com)

* Wed Aug 08 2012 Michael Schenck <michael@tumblr.com> 1.0.0-2.tumblr
- new package built with tito