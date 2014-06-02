# base of the On My Way OS image

%include sl6.ks

%packages
ansible
ipmiutil
freeipmi
openssh-server
git
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

cat > /usr/bin/hw_report.sh <<EOF
#!/bin/bash -x

# switch to tty7 so that logs show on the screen
chvt 7

function get_network_interfaces {
    ls /sys/class/net | grep -v 'lo'
}

function check_nic_link {
    _nic="$1"
    _link="$(cat /sys/class/net/${_nic}/carrier)"
    if [ $_link -eq 1 ]
    then
        return 0
    else
        return 1
    fi
}

function get_dhcp_ip {
    _nic="$1"
    if dhclient -1 $_nic &>/dev/null
    then
        return 0
    else
        return 1
    fi
}

nics="$(get_network_interfaces)"

for n in $nics
do
    /sbin/ip link set $n up
done

# chill for a bit in case the network is slow to wake up
# 30s allows lldpd time to send hellos
sleep 30s

# find a nic with a link and try dhcp
for n in $nics
do
    if check_nic_link $n
    then
        if get_dhcp_ip $n
        then
            break
        else
            echo "dhcp failed in $n"
        fi
    else
        echo "no carrier on $n"
    fi
done

git clone \$GITURL /root/dest
cd /root/dest
/usr/bin/ansible-playbook playbook.yml --connection=local

EOF

chmod +x /usr/bin/hw_report.sh

echo '---> configuring OpenIPMI'
/sbin/chkconfig ipmi on


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
