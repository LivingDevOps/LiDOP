require 'spec_helper'
describe 'Test Portal installation' do

  describe file('/var/lidop/www') do
    it { should be_directory }
  end

  describe command('docker images') do
    its(:stdout) { should contain ("registry.service.lidop.local:5000/lidop/nginx") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("portal_web") }
  end

  describe command('docker service ps portal_web') do
    its(:stdout) { should contain ("Running") }
  end

end
