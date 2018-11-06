require 'spec_helper'
describe 'Test OpenLdap installation' do

  describe command('docker service ls') do
    its(:stdout) { should contain ("openldap_openldapdb") }
  end

  describe command('docker service ps openldap_openldapdb') do
    its(:stdout) { should contain ("Running") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("openldap_openldapui") }
  end

  describe command('docker service ps openldap_openldapui') do
    its(:stdout) { should contain ("Running") }
  end

end
