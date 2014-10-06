#!/bin/bash

# add nat netowrk

NATNAME=lifemapper
NETWORK=10.0.3.0/24

vboxmanage natnetwork add   --netname ${NATNAME} --network ${NETWORK} --enable --dhcp off
vboxmanage natnetwork start --netname ${NATNAME}
vboxmanage list natnets

