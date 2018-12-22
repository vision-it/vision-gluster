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
  Boolean $force_volume = false, # required for creating volume in root-partition

  ) {

  $major = split($release, '\.')[0]

  # set up gluster repo with appropriate version
  apt::source { 'glusterfs':
    location => "http://download.gluster.org/pub/gluster/glusterfs/${major}/${release}/Debian/${::lsbdistcodename}/amd64/apt/",
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      id         => 'F9C958A3AEE0D2184FAD1CBD43607F0DC2F8238C',
      key_source => "https://download.gluster.org/pub/gluster/glusterfs/${release}/rsa.pub",
    },
    pin      => '500',
    notify   => Exec['apt_update'],
  }

  # installs gluster server and client packages
  class { '::gluster':
    server                 => true,
    client                 => true,
    # as per current module logic 'repo => false' is correct!
    repo                   => false,
    use_exported_resources => false,
    require                => Apt::Source['glusterfs']
  }

  gluster::peer { $peers:
    require => Class[::gluster::service],
  }

  gluster::volume { $volume_name:
    replica => $replica,
    arbiter => $arbiter,
    bricks  => $bricks,
    options => $volume_options,
    force   => $force_volume,
    require => Gluster::Peer[ $peers ],
  }

  if ! empty($mount_path) {
    file { $mount_path:
      ensure => directory,
    }

    gluster::mount { $mount_path:
      volume  => "${host}:/${volume_name}",
      atboot  => true,
      options => $mount_options,
      require => File[$mount_path],
    }
  }
}
