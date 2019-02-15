require 'spec_helper_acceptance'

describe 'vision_gluster' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_gluster::node': }
      FILE

      # This module is only implemented for Debian Stretch
      if os[:release].to_i == 9
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end
    end
  end

  context 'packages installed' do
    if os[:release].to_i == 9
      describe package('glusterfs-client') do
        it { is_expected.to be_installed }
      end
      describe package('glusterfs-server') do
        it { is_expected.to be_installed }
      end
      describe package('glusterfs-common') do
        it { is_expected.to be_installed }
      end
    end
  end

  context 'files provisioned' do
    if os[:release].to_i == 9
      describe file('/opt/brick1') do
        it { is_expected.to be_directory }
      end
    end
  end
end
