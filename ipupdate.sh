####################
## NOT FINIFHED ####
####################

#! /bin/sh
echo date >> /home/pi/file.txt
#curl ifconfig.co 2>/dev/null > /tmp/ip.tmp
#&& (diff /tmp/ip.tmp /tmp/ip || (mv /tmp/ip.tmp /tmp/ip && ssh root@DNSIP1 "/root/update_ip.sh $(cat /tmp/ip)")); curl ifconfig.co 2>/dev/null > /tmp/ip.tmp2 && (diff /tmp/ip.tmp2 /tmp/ip2 || (mv /tmp/ip.tmp2 /tmp/ip2 && ssh root@192.210.238.236 "/root/update_ip.sh $(cat /tmp/ip2)"))