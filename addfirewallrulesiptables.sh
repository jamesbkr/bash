#!/bin/bash
RULES=("443,tcp" "80,tcp" "5647,tcp,amqp" "8000,tcp,HTTPS" "8140,tcp,HTTPS" "9090,tcp,HTTPS" "5000,tcp,HTTPS" "5646,tcp,amqp" "22,tcp,SSH" "53,tcp,DNS" "53,udp,DNS" "67,udp,DHCP" "68,udp,DHCP" "69,udp,TFTP" "8443,tcp,HTTP" "7911,tcp,DHCP" "389,tcp,LDAP" "636,tcp,LDAPS" "5900,tcp,SSL" "5930,tcp,TLS")

for INDEX in ${RULES[@]}; do 
	IFS=',' read -ra PROPS <<< ${INDEX}
	iptables -A INPUT -p ${PROPS[1]} --dport ${PROPS[0]} -j ACCEPT
done

iptables -P OUTPUT ACCEPT
iptables -L -v

