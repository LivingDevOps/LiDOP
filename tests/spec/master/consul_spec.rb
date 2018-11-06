require 'spec_helper'
describe 'Test Consul installation' do

  describe file('/var/lidop/consul') do
    it { should be_directory }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("consul_master") }
  end

  describe command('docker service ps consul_master') do
    its(:stdout) { should contain ("Running") }
  end

end
