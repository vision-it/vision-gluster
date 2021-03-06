# Class: vision_gluster::server
# ===========================
#
# Hint: Bricks and Volumes are not managed via Puppet
#

class vision_gluster::server (

) {

  # Using the GlusterFS Repo to get a newer version
  contain vision_gluster::repo

  package { 'glusterfs-server':
    ensure  => present,
    require => Class['vision_gluster::repo'],
  }

  service { 'glusterd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['glusterfs-server'],
  }

}
