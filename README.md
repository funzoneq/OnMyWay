OnMyWay
=======

An Live CD for system intake for Collins and automated provisioning of bare metal with Ansible.

# Setting up PXE
If you are building a collins stack use this https://github.com/funzoneq/collins-ipxe-router or without iPXE:

    sudo yum -y install syslinux tftp-server
    sudo sed -i 's/disable\s*=\s*yes/disable = no/' /etc/xinetd.d/tftp
    sudo cp /usr/share/syslinux/{pxelinux.0,menu.c32,memdisk,mboot.c32,chain.c32} /var/lib/tftpboot
    sudo mkdir /var/lib/tftpboot/pxelinux.cfg

    echo "allow booting;
    allow bootp;
    option option-128 code 128 = string;
    option option-129 code 129 = text;
    next-server xxx.xxx.xxx.xxx; 
    filename "/pxelinux.0";" > /etc/dhcp/dhcpd.conf

# Compile it yourself
    sudo yum -y install livecd-tools createrepo git
    git clone https://github.com/funzoneq/OnMyWay.git omw
    cd omw/os/
    sudo ./make
    or if you have little memory:
    sudo TMP_DIR=/root/tmp/ ./make
    
# Download the pre-built PXE boot binaries

    wget http://vps.us.freshway.biz/OnMyWay/initrd0.img -O /var/lib/tftpboot/omw/initrd0.img
    wget http://vps.us.freshway.biz/OnMyWay/vmlinuz0 -O /var/lib/tftpboot/omw/vmlinuz0

# Moving the image to production
    sudo mkdir /var/lib/tftpboot/omw/
    sudo cp tftpboot/{initrd0.img,vmlinuz0} /var/lib/tftpboot/omw/
    sudo cp ../pxe/default /var/lib/tftpboot/pxelinux.cfg
