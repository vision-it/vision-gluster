require 'spec_helper_acceptance'

describe 'vision_gluster::server' do
  context 'with defaults' do
    it 'run idempotently' do
      setup = <<-FILE
        # Just so that we dont get an error while starting the service
        file { '/etc/init.d/glusterd':
          ensure => file,
          mode   => '0755',
        }
      FILE
      apply_manifest(setup, accept_all_exit_codes: true, catch_failures: false)


      pp = <<-FILE
        class { 'vision_gluster::server': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('glusterfs-server') do
      it { is_expected.to be_installed }
    end
    describe package('glusterfs-common') do
      it { is_expected.to be_installed }
    end
  end
end
