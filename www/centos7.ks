skipx
text
eula --agreed

url --url=http://mirrors.cat.pdx.edu/centos/7.0.1406/os/x86_64/

timezone America/New_York --isUtc
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'

network --bootproto=dhcp --onboot=yes --hostname=centos7-minimal

authconfig --enableshadow --passalgo=sha512
rootpw --plaintext vagrant
user --name=vagrant --plaintext --password=vagrant

firewall --disabled
selinux --permissive

zerombr
clearpart --all --initlabel --drives=sda
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm

repo --name="updates" --baseurl="http://mirrors.cat.pdx.edu/centos/7.0.1406/updates/x86_64/"
repo --name="puppet-deps" --baseurl="http://yum.puppetlabs.com/el/7/dependencies/x86_64/"
repo --name="puppet" --baseurl="http://yum.puppetlabs.com/el/7/products/x86_64/"

reboot

%packages
@base
@core
puppet
%end

%post
# Clear firmware
yum remove -y *firmware

# Clear motd
rm -f /etc/motd && touch /etc/motd

# more RHEL, but does no harm
echo "UseDNS no" >> /etc/ssh/sshd_config

# Override some defaults
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/^Defaults\ requiretty/\#Defaults\ requiretty/g /etc/sudoers'

# Nopasswd for sudo
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers
echo "vagrant  ALL=NOPASSWD:ALL" >> /etc/sudoers
%end