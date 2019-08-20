# Class: vision_gluster::node
# ===========================

class vision_gluster::node (

  String $apt_repo_key,
  String $release, # should be major.minor (e.g. 5.1)
  Integer $replica,
  Integer $arbiter,
  Array[String] $bricks,
  Array[String] $peers, # nodes in the cluster
  String $volume_name,
  String $mount_path,
  Array[String] $volume_options = [],
  String $mount_options = 'noatime,nodev,nosuid',
  String $mount_host = $::fqdn, # from whom to pull the gluster mount
  Boolean $manage_repo = false,

) {

  if $manage_repo {
    contain vision_gluster::repo
  }

  # installs gluster server and client packages
  class { '::gluster':
    server                 => true,
    client                 => true,
    repo                   => false,
    use_exported_resources => false,
  }

  # check if there are already servers connected to this cluster
  $known_peers = $::gluster_peer_list
  if $known_peers == undef or ! empty( split($known_peers, ',') - ($peers - $::fqdn) ) {
    notice('Please join all servers into a cluster by running `gluster peer probe HOSTNAME` from one of the good hosts')
  }

  # check if the volume is already set up on this host
  $vols = $::gluster_volume_list
  if $vols == undef or ! $volume_name in split($vols, ',') {
    notice("Create the Gluster Volume ${volume_name} by running `/usr/local/sbin/gluster-create-${volume_name}.sh`")
  } else {
    if ! empty($mount_path) {
      # ensure mount path is present, but only if it's not already defined by puppet
      if !defined(File[$mount_path]) {
        file { $mount_path:
          ensure => directory,
        }
      }

      gluster::mount { $mount_path:
        volume  => "${mount_host}:/${volume_name}",
        atboot  => true,
        options => $mount_options,
        require => File[$mount_path],
      }
    }
  }

  file { "/usr/local/sbin/gluster-create-${volume_name}.sh":
    ensure  => present,
    content => template('vision_gluster/gluster-create-volume.sh.erb'),
    mode    => '0750',
  }
}
