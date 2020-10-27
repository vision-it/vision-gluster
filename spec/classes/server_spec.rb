# frozen_string_literal: true

require 'spec_helper'
require 'hiera'

describe 'vision_gluster::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          gluster_peer_list: 'foobar,barfoo',
          gluster_volume_list: 'volFoo,volBar'
        )
      end
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
