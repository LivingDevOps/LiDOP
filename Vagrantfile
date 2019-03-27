require 'yaml'
require 'fileutils'
require "open3"


# load all needed vagrant helper files
Dir["#{File.dirname(__FILE__)}/vagrant/Vagrantfile.*.rb"].each {|file| require file }

# if the .config file not exists, create a default one out of the template
config_file="#{File.dirname(__FILE__)}/.lidop_config.yaml"
if(File.exist?(config_file)) 
else 
    FileUtils.cp("#{File.dirname(__FILE__)}/templates/lidop_config.yaml", config_file)
end

config_file="#{File.dirname(__FILE__)}/.vagrant_config.yaml"
if(File.exist?(config_file)) 
else 
    FileUtils.cp("#{File.dirname(__FILE__)}/templates/vagrant_config.yaml", config_file)
end

# init new settins (user and password question)
settings = Settings.new

# load the configuration out of *.config.yaml
configuration = settings.readConfig

# ask for username and password
if ARGV.include? "up" or ARGV.include? "provision"
    if(File.exist?(".env")) 
        File.open('.env').each do |line|
            puts "Set #{line.split('=')[0]} to #{line.split('=')[1]}"
            ENV[line.split('=')[0].strip] = line.split('=')[1].strip
        end
    end
    
    settings.init()
end

# start vagrant part
Vagrant.configure("2") do |config|

    # if a extend script is defined, copy the file to remote machine
    if "#{ENV['LIDOP_EXTEND']}" != ""
        config.vm.provision "file", source: ENV['LIDOP_EXTEND'], destination: "/vagrant/extensions/extend.yml"
    end

    # define default installation script
    ansible_script = <<-SCRIPT 
        export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg
        export LIDOP_EXTEND=#{ENV['LIDOP_EXTEND_NEW']}
        export ANSIBLE_VAULT_PASSWORD=lidop
        dos2unix /vagrant/install/vault-env
        chmod +x /vagrant/install/vault-env
        ansible-playbook /vagrant/install/install.yml --vault-password-file /vagrant/install/vault-env -e '
        root_password=#{settings.password}
        root_user=#{settings.user_name}
    SCRIPT
    
    # define default test script
    test_script = <<-SCRIPT
        docker run --rm  \
        -v /vagrant/tests/:/serverspec \
        -v /var/lidop/www/tests/:/var/lidop/www/tests/ \
        -e USERNAME=#{settings.user_name} \
        -e PASSWORD=#{settings.password}  \
        -e HOST=$IPADDRESS \
        -e HOSTNAME=$HOSTNAME \
        -e TEST_HOST=$TEST_HOST \
        registry.service.lidop.local:5000/lidop/serverspec:#{configuration["docker_image_version"]} test
    SCRIPT

    # no parallel start of the machines
    ENV['VAGRANT_NO_PARALLEL'] = 'yes'

    # read the number of workers and loop
    workers = configuration["nodes"]
    (0..workers).each do |worker|

        # set the name of the vagrant machine
        config.vm.define "lidop_#{worker}" do |machine_config|

            # set the hostname
            machine_config.vm.hostname = "LiDOP#{worker}"  
            
            # common scripts
            if configuration["install_mode"]== "online"
                machine_config.vm.provision "shell", path: "./scripts/ansible.sh"
            end
    
            # script for virtualbox
            machine_config.vm.provider :virtualbox do |v, override|
                Virtualbox.init(v, override, worker, settings, configuration, ansible_script, test_script)
                if(worker == workers)
                    override.vm.provision "show_info", type: "show_info"
                end
            end
        end
    end
end