#!/bin/bash

FILESYSTEM=("5G,/var/cache/pulp/")
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
	COUNT="`expr ${COUNT} + 1`"
done
