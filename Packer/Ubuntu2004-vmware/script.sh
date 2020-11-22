  
# Apply updates and cleanup Apt cache
#

apt install open-vm-tools -y
apt-get update ; apt-get -y dist-upgrade
apt-get -y clean



# Disable swap - generally recommended for K8s, but otherwise enable it for other workloads
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Reset the machine-id value. This has known to cause issues with DHCP
#
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Reset any existing cloud-init state
#
cloud-init clean -s -l



touch /etc/cloud/cloud-init.disabled
rm -rf /etc/netplan/50-cloud-init.yaml
apt purge cloud-init -y
apt autoremove -y

# Don't clear /tmp
sed -i 's/D \/tmp 1777 root root -/#D \/tmp 1777 root root -/g' /usr/lib/tmpfiles.d/tmp.conf

# Remove cloud-init and rely on dbus for open-vm-tools
sed -i 's/Before=cloud-init-local.service/After=dbus.service/g' /lib/systemd/system/open-vm-tools.service

# cleanup current ssh keys so templated VMs get fresh key
rm -f /etc/ssh/ssh_host_*

# add check for ssh keys on reboot...regenerate if neccessary
tee /etc/rc.local >/dev/null <<EOL
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#

# By default this script does nothing.
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# make the script executable
chmod +x /etc/rc.local

# cleanup apt
apt clean

# reset the machine-id (DHCP leases in 18.04 are generated based on this... not MAC...)
echo "" | tee /etc/machine-id >/dev/null

# cleanup shell history and shutdown for templating
history -c
history -w

#remove 00 network adapter
rm /etc/netplan/00-installer-config.yaml

fstrim /