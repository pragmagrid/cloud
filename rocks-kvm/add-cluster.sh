#!/bin/bash

# Execute ./add-clsuter.sh -h
# to see what commands will be executed

######  start edit for your cluster  ##########
# info about the virtual frontend
IP=198.202.88.204
FE_NAME=rocks-204
VLAN=18
FE_CONTAINER=fiji
ZFSBASE="state/kvmdisks"
SIZE=72
FMEM=8192
FCPUS=8

# info about the virtual compute nodes
CONTAINER_HOSTS="vm-container-0-0 vm-container-0-1"
FILEBASE=/share/vmdisks/kvm
NUM_COMPUTE=2
CMEM=2048
CCPUS=4

if [ $# -eq 1 ];  then
    COM=echo
    echo "Commands to add the cluster:"
else
    COM=
fi
######  end edit ################################

createVolume  () {
    if [ -x /sbin/zfs ] ; then
        # assuming zfs volume for the frontend image
        result=`zfs list -t volume | grep $FE_NAME | awk '{print $1}'`
        if [ "$result" == "$ZFSBASE/$FE_NAME" ] ; then
            echo "Zvol $ZFSBASE/$FE_NAME exists"
        else 
            zfs create -V ${SIZE}G $ZFSBASE/$FE_NAME
        fi
        FE_DISKTYPE="phy:/dev/$ZFSBASE/$FE_NAME,vda,virtio"
    else
        # assuming regular file for the frontend image
        FE_DISKTYPE="file:/$FILEBASE/$FE_NAME.vda,vda,virtio"
	fi
}

# add cluster 
addCluster () {
    # check if cluster already exists
    result=`rocks list cluster | grep $FE_NAME | awk -F: '{print $1}'`
    if [ "$result" == "$FE_NAME" ] ; then
        echo "Virtual cluster $FE_NAME exists, no commands will be executed."
        COM=echo
    fi

    # add cluster 
    $COM rocks add cluster $IP $NUM_COMPUTE \
        fe-name=$FE_NAME \
        fe-container=$FE_CONTAINER \
        container-hosts="$CONTAINER_HOSTS" \
        cluster-naming=true \
        vlan=$VLAN
}

# set VMs disks
setDisks () {
    # set compute nodes images disks 
    cnodes=`rocks list cluster $FE_NAME | tail -n +3 |  awk '{print $2}'`
    for h in $cnodes;
    do
        $COM rocks set host vm $h disk="file:/$FILEBASE/$FE_NAME/$h.vda,vda,virtio"
        $COM rocks set host vm $h mem=$CMEM
        $COM rocks set host cpus $h cpus=$CCPUS
    done

    # set frontend images disk, its size, memory, cpus
    $COM rocks set host vm $FE_NAME disk="$FE_DISKTYPE"
    $COM rocks set host vm $FE_NAME disksize=$SIZE
    $COM rocks set host vm $FE_NAME mem=$FMEM
    $COM rocks set host cpus $FE_NAME cpus=$FCPUS

}

createVolume
addCluster
setDisks

