#!/bin/bash

# remove nat network 

NATNAME=lifemapper

vboxmanage list natnets
vboxmanage natnetwork stop --netname ${NATNAME}
vboxmanage natnetwork remove --netname ${NATNAME}

