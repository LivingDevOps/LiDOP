require 'spec_helper'
describe 'Test Registry installation' do

  describe command('docker service ls') do
    its(:stdout) { should contain ("registry_registry") }
  end

  describe command('docker service ps registry_registry') do
    its(:stdout) { should contain ("Running") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("registry_registrygui") }
  end

  describe command('docker service ps registry_registrygui') do
    its(:stdout) { should contain ("Running") }
  end

end
