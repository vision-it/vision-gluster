require 'spec_helper_acceptance'

describe 'vision_gluster::client' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_gluster::client': }
      FILE

      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'packages installed' do
    describe package('glusterfs-client') do
      it { is_expected.to be_installed }
    end
  end
end
