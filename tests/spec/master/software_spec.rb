require 'spec_helper'
describe 'Test Software installation' do

  describe package('apt-transport-https') do
    it { should be_installed }
  end

  describe package('ca-certificates') do
    it { should be_installed }
  end

  describe package('python-pip') do
    it { should be_installed }
  end

  describe package('docker-ce') do
    it { should be_installed }
  end

  describe package('python-setuptools') do
    it { should be_installed }
  end

  describe port(2375) do
    it { should be_listening }
  end

end
