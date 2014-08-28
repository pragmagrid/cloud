#!/bin/bash

# Run on a VM locally after it is build 
# Setup needed minimal rocks directories before 10GB AMI bundle is created
# 

setDefaults () {
    ARCH=`arch`
    VER=`rocks report version`

    BASE=/state/partition1
    mkdir -p $BASE

    BASEROCKS=$BASE/rocks/install
    mkdir -p $BASEROCKS

    NODEDIR=$BASEROCKS/rocks-dist/$ARCH/build/nodes
    mkdir -p $NODEDIR
}

makeBaseDirs () {
    DIRS="apps bio home opal"
    for i in $DIRS ;
    do
        cp -p -R /export/$i $BASE
    done
}

makeRollsDirs () {
    DIRS=`ls /export/rocks/install/rolls/`
    for i in $DIRS ; 
    do
        echo $i
        ROLLDIR="rocks/install/rolls/$i/$VER/$ARCH"
        RPMDIR="RedHat/RPMS"
        mkdir -p $BASE/$ROLLDIR/$RPMDIR
        if [ -d /export/rocks/install/rolls/$i ] ; then
            cp -p /export/$ROLLDIR/$RPMDIR/roll-$i-kickstart*rpm $BASE/$ROLLDIR/$RPMDIR
            cp -p /export/$ROLLDIR/roll-$i.xml $BASE/$ROLLDIR
        fi
    done
}

copyNodesXml () {
    ORDER="    
    rlo 
    autofs-server  
    apache  
    wordpress-data  
    dns-server  
    sge-server  
    networking-server  
    dhcp-server  
    condor-server  
    ca  
    ssl-server  
    server-firewall  
    411-server  
    bio-base  
    mail-server 
    ntp-server  
    opal  
    pdb2pqr-server  
    autodock-server  
    apbs
    "
    for i in $ORDER
    do
	SRC=/export/rocks/install/rocks-dist/x86_64/build/nodes
	cp -p  $SRC/$i.xml $NODEDIR
    done

}

finalize () {
    umount /export
    mv /export /export.orig
    ln -s /state/partition1 /export
    sed -i "s/LABEL=\/export/#LABEL=\/export/" /etc/fstab
    mkdir /ebs 
}

setDefaults 
makeBaseDirs
makeRollsDirs
copyNodesXml
finalize

