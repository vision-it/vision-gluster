require 'spec_helper_acceptance'

describe 'vision_gluster::server' do
  context 'with defaults' do
    it 'run idempotently' do
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
