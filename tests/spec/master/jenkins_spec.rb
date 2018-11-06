require 'spec_helper'
describe 'Test Jenkins installation' do

  describe file('/var/lidop/jenkins') do
    it { should be_directory }
  end

  describe command('docker images') do
    its(:stdout) { should contain ("registry.service.lidop.local:5000/lidop/jenkins") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("jenkins_jenkins") }
  end

  describe command('docker service ps jenkins_jenkins') do
    its(:stdout) { should contain ("Running") }
  end

end
