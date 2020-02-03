# Class: vision_gluster::repo
# ===========================

class vision_gluster::repo (

  String $release = $vision_gluster::release,

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

}
