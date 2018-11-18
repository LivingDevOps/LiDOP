require 'yaml'
require 'fileutils'

# load all needed vagrant helper files
Dir["#{File.dirname(__FILE__)}/vagrant/Vagrantfile.*.rb"].each {|file| require file }


# if the .config file not exists, create a default one out of the template
config_file="#{File.dirname(__FILE__)}/.config.yaml"
if(File.exist?(config_file)) 
else 
    FileUtils.cp("#{File.dirname(__FILE__)}/templates/config.yaml", config_file)
end

# load the configuration out of .config.yaml
configuration = YAML.load_file("#{File.dirname(__FILE__)}/.config.yaml")

# init new settins (user and password question)
settings = Settings.new

# init variables file
if ARGV.include? "up"
    variable_file="#{File.dirname(__FILE__)}/.variables.yaml"
    File.open("#{File.dirname(__FILE__)}/.variables.yaml", 'w') {|f| f.write configuration["general"].to_yaml } #Store
end

# ask for username and password
if ARGV.include? "up" or ARGV.include? "provision"
    settings.init1()
end

# start vagrant part
Vagrant.configure("2") do |config|

    # define default installation script
    ansible_script = <<-SCRIPT 
        export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg
        export LIDOP_EXTEND=#{ENV['LIDOP_EXTEND_NEW']}
        ansible-playbook -v /vagrant/install/install.yml -e '
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
        registry.service.lidop.local:5000/lidop/serverspec:latest test
    SCRIPT

    # no parallel start of the machines
    ENV['VAGRANT_NO_PARALLEL'] = 'yes'

    # read the number of workers and loop
    workers = configuration["general"]["nodes"]
    (0..workers).each do |worker|

        # set the name of the vagrant machine
        config.vm.define "lidop_#{worker}" do |machine_config|

            # set the hostname
            machine_config.vm.hostname = "LiDOP#{worker}"  

            # if a extend script is defined, copy the file to remote machine
            if "#{ENV['LIDOP_EXTEND']}" != ""
                override.vm.provision "file", source: ENV['LIDOP_EXTEND'], destination: "/tmp/extend.yml"
                ENV['LIDOP_EXTEND_NEW'] = "/tmp/extend.yml"
            end
            
            # common scripts
            if configuration["general"]["install_mode"]== "local"
            elsif configuration["general"]["install_mode"] == "online"
                machine_config.vm.provision "shell", path: "./scripts/ansible.sh"
            elsif configuration["general"]["install_mode"] == "offline"
            end
            machine_config.vm.provision "shell", path: "./scripts/vagrant.sh"
    
            # script for virtualbox
            machine_config.vm.provider :virtualbox do |v, override|
                Virtualbox.init(v, override, worker, settings, configuration, ansible_script, test_script)
                if(worker == workers)
                    override.vm.provision "message1", type: "local_shell", message: "LiDOP ist ready to use. \nUser: #{settings.user_name}\nAccess under: ", show: "base_url"
                    override.vm.provision "message2", type: "local_shell", message: "Secret Password: ", show: "secret_password"
                end
            end

            # script for AWS
            machine_config.vm.provider :aws do |aws, override|
                AWS.init(aws, override, worker, settings, configuration, ansible_script, test_script)
                if(worker == workers)
                    override.vm.provision "message1", type: "local_shell", message: "LiDOP ist ready to use. \nUser: #{settings.user_name}\nAccess under: ", show: "base_url"
                    override.vm.provision "message2", type: "local_shell", message: "Secret Password: ", show: "secret_password"
                end
            end
            
            # script for AZURE (in prpogress)
            # machine_config.vm.provider :azure do |azure, override|
            #   Azure.init(azure, override, worker, settings, configuration, ansible_script, test_script)
            # end
        end
    end
end