# System Configuration Base for Archlinux

This conatins a Sysconfig base directory that contains the smallest amount
of configuration files for a hardened and optomized Archlinux configuration.

To use this, drop it in your system configuration directory (usually /opt/sysconfig),
create the sysconfig pointer "printf 'SYSCONFIG=/opt/sysconfig\n' > /etc/sysconfig.conf" and then
run relink, by "bash /opt/sysconfig/bin/relink /opt/sysconfig /". This will link all the
new configuration files in place.
