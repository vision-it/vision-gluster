# Class: vision_gluster::node
# ===========================

class vision_gluster::node (

  String $release,
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

  # set up gluster repo with appropriate version
  class { '::gluster::repo::apt':
    release => $release,
    version => 'LATEST',
  }

  # installs gluster server and client packages
  class { '::gluster':
    server                 => true,
    client                 => true,
    # as per current module logic 'repo => false' is correct!
    repo                   => false,
    use_exported_resources => false,
    require                => Class[::gluster::repo::apt]
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
