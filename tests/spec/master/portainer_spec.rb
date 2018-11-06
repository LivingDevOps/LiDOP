require 'spec_helper'
describe 'Test Portainer installation' do

  describe file('/var/lidop/postgres/data') do
    it { should be_directory }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("postgres_adminer") }
  end

  describe command('docker service ps postgres_adminer') do
    its(:stdout) { should contain ("Running") }
  end

  describe command('docker service ls') do
    its(:stdout) { should contain ("postgres_postgres") }
  end

  describe command('docker service ps postgres_postgres') do
    its(:stdout) { should contain ("Running") }
  end

end
