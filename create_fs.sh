#!/bin/bash


# Add size and mount point for your file systems and it will mount persistently
FILESYSTEM=("5G,/var/cache/pulp/")
# Name Volume Group to create
VG=mainvg
# Name File system type
FSTYPE=xfs
# Name Partition to use
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
