#!/bin/bash
SCRIPTSDIR="CUCKOODIR/utils/crontab/"

pkill cuckoo_monitor.sh
touch /var/run/cuckoo_monitor
for i in cuckoo_all openvpn; do
	/etc/init.d/$i stop
done
pkill ping
service netfilter-persistent restart
/etc/init.d/fail2ban restart
/etc/init.d/openvpn start
sleep 10
/etc/init.d/cuckoo_all start
sleep 10
${SCRIPTSDIR}/root/openvpn_route.sh >/dev/null 2>&1
su - CUCKOO_USER -c "${SCRIPTSDIR}/cuckoo/openvpn_keepalive.sh"
rm -f /var/run/cuckoo_monitor
vboxmanage hostonlyif ipconfig SANDINT --ip SANDIP --netmask 255.255.255.0
su - cuckoo -c "vboxmanage hostonlyif ipconfig SANDINT --ip SANDIP --netmask 255.255.255.0"
