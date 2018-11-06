require 'spec_helper'
describe 'Test Portal installation' do

  describe file('/var/lidop/www') do
    it { should be_directory }
  end

  describe command('docker images') do
    its(:stdout) { should contain ("registry.service.lidop.local:5000/lidop/nginx") }
  end

end
