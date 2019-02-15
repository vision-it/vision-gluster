# Initialization

# vision-gluster

[![Build Status](https://travis-ci.org/vision-it/vision-gluster.svg?branch=production)](https://travis-ci.org/vision-it/vision-gluster)

This module automatically configures the GlusterFS repositories, install the required gluster packages and adds some hints to to initialize a cluster and create a volume.

## Setting Up a new Cluster

When setting up a new cluster, the peers (nodes) need to be introduced to each other first.
The gluster daemon must be running for this (the module automatically does that).
From one node the other peers need to be probe:
```
gluster peer probe bob
gluster peer probe charlie
```

The status of the peers in the cluster can be checked with:
```
gluster pool list
UUIDHostname           State
5a72f064-4d63-4599-8fce-1abddc5ff682 alice     Connected
f78a0252-1e02-4312-ab91-81b51afbf83e bob       Connected
e5e7a94b-adfd-405e-ac96-fbca027a7044 localhost Connected
vision11.prd (int) :: ~ : gluster peer status
Number of Peers: 2

Hostname: alice
Uuid: 5a72f064-4d63-4599-8fce-1abddc5ff688
State: Peer in Cluster (Connected)

Hostname: bob
Uuid: f78a0252-1e02-4312-ab91-81b51afbf831
State: Peer in Cluster (Connected)
```

Afterwards, a new volume can be created and started.
The module places a script for this task under `/usr/local/sbin/gluster-create-VOLUMENAME.sh`
Once all nodes have been introduced to each other, this script can be run from any node and only has to be run once in the entire cluster.

## Usage

Include in the *Puppetfile*:

```
mod vision_gluster:
    :git => 'https://github.com/vision-it/vision-gluster.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_gluster
```
