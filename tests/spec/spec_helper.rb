require 'serverspec'

set :backend, :ssh
set :host, ENV['HOST']
set :ssh_options, :user => ENV['USERNAME'], :port => 22, :password => ENV['PASSWORD']