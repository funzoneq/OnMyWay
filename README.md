OnMyWay
=======

An Live CD for system intake for Collins and automated provisioning of bare metal with Ansible.

# Getting started
    sudo yum -y install livecd-tools createrepo git
    git clone git@github.com:funzoneq/OnMyWay.git omw
    cd omw/os/
    sudo ./make

# Moving the image to production
    sudo yum -y install syslinux tftp-server
    sudo sed -i 's/disable\s*=\s*yes/disable = no/' /etc/xinetd.d/tftp
    sudo cp /usr/share/syslinux/{pxelinux.0,menu.c32,memdisk,mboot.c32,chain.c32} /var/lib/tftpboot
    sudo mkdir /var/lib/tftpboot/pxelinux.cfg
