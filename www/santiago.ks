text

url --url=http://mirror.rit.edu/centos/6.5/os/x86_64/

timezone --utc America/New_York
lang en_US.UTF-8
keyboard us

network --bootproto=dhcp --onboot=yes --hostname='centos-6.5.example.com'

authconfig --enableshadow --passalgo=sha512
rootpw --plaintext vagrant
user --name=vagrant --plaintext --password=vagrant

firewall --disabled
selinux --permissive

zerombr
clearpart --all --initlabel --drives=sda
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
autopart

repo --name="updates" --baseurl="http://mirror.rit.edu/centos/6.5/updates/x86_64/"
repo --name="puppet-deps" --baseurl="http://yum.puppetlabs.com/el/6/dependencies/x86_64/"
repo --name="puppet" --baseurl="http://yum.puppetlabs.com/el/6/products/x86_64/"

reboot

%packages
@base
@core
puppet
puppetlabs-release

%post
# Clear firmware
yum remove -y *firmware

# Add vagrant user to sudoers
echo "vagrant  ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers.d/vagrant

