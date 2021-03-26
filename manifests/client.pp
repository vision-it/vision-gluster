# Class: vision_gluster::client
# ===========================
#
# Parameters
# ----------
#
# @param mounts Mounts to create on the system
#
# Examples
# --------
#
# @example
# Manage GlusterFS Client Installation
#
# class { 'vision_gluster::client':
#   mounts => {
#   '/mnt' => {
#     device => 'server1:/volume1',
#   }
#  }
# }
#

class vision_gluster::client (

  Hash $mounts = {},

) {

  # Using the GlusterFS Repo to get a newer version
  contain vision_gluster::repo

  package { 'glusterfs-client':
    ensure  => present,
    require => Class['vision_gluster::repo'],
  }

  # User needs to provide source and target
  $mount_defaults = {
    ensure   => mounted,
    fstype   => 'glusterfs',
    remounts => false,
    atboot   => 'yes',
    dump     => 0,
    pass     => 0,
    options  => 'defaults,_netdev,noauto,x-systemd.automount',
    require  => Package['glusterfs-client'],
  }

  create_resources(mount, $mounts, $mount_defaults)

}
