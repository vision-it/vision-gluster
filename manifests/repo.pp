# Class: vision_gluster::repo
# ===========================
#
# Parameters
# ----------
#
# @param release Basically LSB Distcodename
# @param repo_key Key for the Gluster Apt repository
# @param repo_key_id Key ID for the Gluster Apt repository
#
# Examples
# --------
#
# @example
# contain ::vision_gluster::repo
#

class vision_gluster::repo (

  String $release,
  String $repo_key,
  String $repo_key_id,

) {

  # set up gluster repo with appropriate version
  apt::source { 'glusterfs':
    location => "http://download.gluster.org/pub/gluster/glusterfs/${release}/LATEST/Debian/${::lsbdistcodename}/amd64/apt/",
    repos    => 'main',
    release  => $::lsbdistcodename,
    key      => {
      id      => $repo_key_id,
      content => $repo_key,
    },
    pin      => '500',
  }
  -> exec { 'gluster-update':
    command     => '/usr/bin/apt-get update',
    logoutput   => 'on_failure',
    refreshonly => true,
  }

}
