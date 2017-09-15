#!/bin/bash

FILESYSTEM=("5G,/var/cache/pulp/" "500G,/var/lib/pulp" "50G,/var/lib/mongodb/" "250M,/var/log/" "10G,/var/lib/pgsql/")
VG=mainvg
FSTYPE=xfs
DEV=/dev/vdb1
COUNT=0

pvcreate ${DEV}
vgcreate ${VG} ${DEV}

for INDEX in ${FILESYSTEM[@]}; do
	IFS=',' read -ra PROPS <<< ${INDEX}
	lvcreate -L ${PROPS[0]} -n lv${COUNT} ${VG}
	mkdir -p ${PROPS[1]}
	mkfs.xfs /dev/${VG}/lv${COUNT}
	mount /dev/${VG}/lv${COUNT} ${PROPS[1]}
	xfs_growfs /dev/${VG}/lv${COUNT} 
	echo "/dev/mapper/${VG}-lv${COUNT} ${PROPS[1]} xfs defaults 0 0" >> /etc/fstab
	COUNT="`expr ${COUNT} + 1`"
done
