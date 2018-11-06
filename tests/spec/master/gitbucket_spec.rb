require 'spec_helper'
describe 'Test Gitbucket installation' do

  describe file('/var/lidop/gitbucket') do
    it { should be_directory }
  end

  describe command('docker images') do
    its(:stdout) { should contain ("registry.service.lidop.local:5000/lidop/gitbucket") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("gitbucket_gitbucket") }
  end

  describe command('docker service ps gitbucket_gitbucket') do
    its(:stdout) { should contain ("Running") }
  end

end
