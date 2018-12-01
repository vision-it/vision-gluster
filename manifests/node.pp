# Class: vision_gluster::node
# ===========================

class vision_gluster::node (

  String $version,
  Integer $replica,
  Integer $arbiter,
  Array[String] $bricks,
  Array[String] $peers, # nodes in the cluster
  String $volume_name,
  String $mount_path,
  String $brick_path,
  Boolean $repo = false,
  Array[String] $volume_options = [],
  String $mount_options = 'noatime,nodev,nosuid',
  String $host = $::fqdn,

  ) {

  file { $brick_path:
    ensure => directory,
  }

  # installs gluster server and client packages
  class { '::gluster':
    server                 => true,
    client                 => true,
    repo                   => $repo,
    use_exported_resources => false,
    version                => $version,
  }

  gluster::peer { $peers:
    require => Class[::gluster::service],
  }

  gluster::volume { $volume_name:
    replica => $replica,
    arbiter => $arbiter,
    bricks  => $bricks,
    options => $volume_options,
    require => Gluster::Peer[ $peers ],
  }

  if ! empty($mount_path) {
    gluster::mount { $mount_path:
      volume  => "${host}:/${volume_name}",
      atboot  => true,
      options => $mount_options,
    }
  }
}
