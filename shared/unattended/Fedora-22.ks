install
KVM_TEST_MEDIUM
text
reboot
lang en_US
keyboard us
network --bootproto dhcp --hostname atest-guest
rootpw 123456
firewall --enabled --ssh
selinux --enforcing
timezone --utc America/New_York
firstboot --disable
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200"
zerombr
poweroff
KVM_TEST_LOGGING

clearpart --all --initlabel
autopart

%packages
@standard
sg3_utils
%end

%post
function ECHO { for TTY in `cat /proc/consoles | cut -f1 -d' '`; do echo "$*" > /dev/$TTY; done }
ECHO "OS install is completed"
grubby --remove-args="rhgb quiet" --update-kernel=$(grubby --default-kernel)
dhclient
chkconfig sshd on
iptables -F
systemctl mask tmp.mount
echo 0 > /selinux/enforce
sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
dnf -y groupinstall c-development development-tools
ECHO 'Post set up finished'
%end
