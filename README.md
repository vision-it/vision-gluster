# vision-gluster

[![Build Status](https://travis-ci.org/vision-it/vision-gluster.svg?branch=production)](https://travis-ci.org/vision-it/vision-gluster)

This module automatically configures the GlusterFS repositories, install the required gluster packages and adds some hints to to initialize a cluster and create a volume.

## Bootrapping a new Cluster

When setting up a new cluster, the peers (nodes) need to be introduced to each other first. The gluster daemon must be running for this (the module automatically does that).

Setting up the Pool:

```
$ server1: gluster peer probe server2
$ server1: gluster peer probe server3
$ server2: gluster peer probe server1

$ server1: gluster pool list
```

Setting up the Volume:

```
$ server1: gluster volume create volume1 replica 3 server1:/data/brick1/volume1 server2:/data/brick1/volume1 server2:/data/brick1/volume1
$ server1: gluster volume start volume1
```

## Usage

Include in the *Puppetfile*:

```
mod vision_gluster:
    :git => 'https://github.com/vision-it/vision-gluster.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_gluster::server
contain ::vision_gluster::client
```
