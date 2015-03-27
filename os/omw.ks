# base of the On My Way OS image

%include sl6.ks

%packages
ruby
ansible
boot_script
breakin
git
ipmitool
lldpd
lshw
openssh-server
ipmitool
dmidecode
%end

%post
# Apply Live OS customizations
echo '*****************************************'
echo '*** On My Way Live OS Image Customizr ***'


echo '---> updating fstab'
cat >> /etc/fstab <<EOL
tmpfs			/tmp		tmpfs	mode=1777	0 0
tmpfs			/var/tmp	tmpfs	mode=1777	0 0
EOL


echo '---> setting hostname'
sed -i -e 's/HOSTNAME=.*/HOSTNAME=omw/' /etc/sysconfig/network


echo '---> rewromwing /etc/issue'
cat > /etc/issue <<EOF
On My Way Live OS v1.0.1
Kernel \r

EOF

echo '---> Modprobe IPMI'
cat > /etc/modprobe.d/ipmi_si.conf <<EOF
alias ipmi_si ipmi_devintf
EOF

echo '---> configuring OpenIPMI'
/sbin/chkconfig ipmievd on


echo '---> configuring rsyslog'
cat >> /etc/rsyslog.conf <<EOL

# Logging
local0.*                                                /var/log/omw.log
local0.*                                                /dev/tty7
EOL

echo '---> disabling selinux'
rm -f /etc/sysconfig/selinux
ln -sf /etc/selinux/config /etc/sysconfig/selinux
sed -i -e "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

echo '---> all done'
echo '*****************************************'
%end
