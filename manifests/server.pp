# Class: vision_gluster::server
# ===========================

class vision_gluster::server () {

  contain vision_gluster::repo

  package { 'glusterfs-server':
    ensure  => present,
    require => Class['vision_gluster::repo']
  }

  service { 'glusterd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => Package['glusterfs-server']
  }

}
