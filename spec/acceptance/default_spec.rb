require 'spec_helper_acceptance'

describe 'vision_gluster' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_gluster::node': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'packages installed' do
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

  context 'files provisioned' do
    describe file('/opt/brick1') do
      it { is_expected.to be_directory }
    end
  end
end
