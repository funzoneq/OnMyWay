lang en_US.UTF-8
keyboard us
timezone Etc/UTC
auth --useshadow --enablemd5
selinux --disabled
firewall --disabled
rootpw onmyway
services --enabled sshd
url --url=http://ftp.nluug.nl/os/Linux/distr/scientific/6/x86_64/os/
repo --name=base     --baseurl=http://ftp.nluug.nl/os/Linux/distr/scientific/6/x86_64/os/
repo --name=epel     --baseurl=http://mirrors.kernel.org/fedora-epel/6/x86_64/
repo --name=fastbugs --baseurl=http://ftp.nluug.nl/os/Linux/distr/scientific/6/x86_64/updates/fastbugs/
repo --name=security --baseurl=http://ftp.nluug.nl/os/Linux/distr/scientific/6/x86_64/updates/security/
repo --name=dell     --baseurl=http://linux.dell.com/repo/hardware/latest/platform_independent/rh60_64/
repo --name=freshway --baseurl=http://vps.us.freshway.biz/CentOS-6-Production-x86_64/RPMS.freshway/
repo --name=lldpd    --baseurl=http://download.opensuse.org/repositories/home:/vbernat/CentOS_CentOS-6/
repo --name=ruby     --baseurl=http://rpms.southbridge.ru/rhel6/ruby-1.9.3/x86_64/
repo --name=omsa     --baseurl=http://linux.dell.com/repo/hardware/latest/platform_independent/rh60_64

%packages --excludedocs
aic94xx-firmware
atmel-firmware
b43-openfwwf
bfa-firmware
efibootmgr
grub
kernel-firmware
ipw2100-firmware
ipw2200-firmware
ivtv-firmware
iwl1000-firmware
iwl100-firmware
iwl3945-firmware
iwl4965-firmware
iwl5000-firmware
iwl5150-firmware
iwl6000-firmware
iwl6000g2a-firmware
iwl6050-firmware
libertas-usb8388-firmware
ql2100-firmware
ql2200-firmware
ql23xx-firmware
ql2400-firmware
ql2500-firmware
rt61pci-firmware
rt73usb-firmware
xorg-x11-drv-ati-firmware
zd1211-firmware
acl
attr
basesystem
bash
coreutils
cpio
dhclient
e2fsprogs
filesystem
glibc
initscripts
iproute
iputils
kbd
ncurses
openssh-server
passwd
policycoreutils
procps
rootfiles
rpm
rsyslog
selinux-policy-targeted
system-config-firewall-base
setup
shadow-utils
sudo
util-linux-ng
vim-minimal
yum
dracut-fips
dracut-network
epel-release
patch
libyaml-devel
libffi-devel
glibc-headers
autoconf
gcc-c++
glibc-devel
patch
readline-devel
zlib-devel
openssl-devel
automake
libtool
bison

-mysql-libs
-cronie
-cronie-anacron
-crontabs
-postfix
-sendmail
-audit

# these are our addons
bash
kernel
passwd
policycoreutils
chkconfig
authconfig
rootfiles
dracut
dracut-kernel
device-mapper
device-mapper-event
%end
