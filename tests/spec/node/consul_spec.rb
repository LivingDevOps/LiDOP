require 'spec_helper'
describe 'Test Consul installation' do

  describe file('/var/lidop/consul') do
    it { should be_directory }
  end

end
