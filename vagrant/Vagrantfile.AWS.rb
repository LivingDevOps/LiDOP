class AWS
    def self.init(aws, override, worker, settings, configuration, ansible_script, test_script)
        
        # Define which box to use
        override.vm.box = "dummy"
        override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

        # set AWS configuration
        aws.access_key_id = configuration["aws"]["ec3_access_key"]
        aws.secret_access_key = configuration["aws"]["ec3_secret_access_key"]
        aws.keypair_name = configuration["aws"]["keypair_name"]
        aws.ami = configuration["aws"]["ami"]
        aws.region = configuration["aws"]["region"]
        aws.instance_type = configuration["aws"]["instance_type"]
        aws.subnet_id = configuration["aws"]["subnet_id"]
        aws.security_groups = configuration["aws"]["security_groups"]
        aws.private_ip_address = configuration["aws"]["private_ip"]
        aws.elastic_ip = configuration["aws"]["elastic_ip"]
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 50 }]

        # set ssh configuration
        override.ssh.private_key_path = configuration["aws"]["private_key_path"]
        override.ssh.username = configuration["aws"]["ssh_user_name"]

        # simulate the /vagrant folder (vagrant only sync this folder for virtualbox)
        override.vm.synced_folder ".", "/vagrant", disabled: true  
        override.vm.provision "shell", inline: "mkdir -p /vagrant"
        override.vm.provision "shell", inline: "chmod 777 -R /vagrant"
        override.vm.provision "file", source: "./configs", destination: "/vagrant/configs"
        override.vm.provision "file", source: "./install", destination: "/vagrant/install"
        override.vm.provision "file", source: "./plugins", destination: "/vagrant/plugins"
        override.vm.provision "file", source: "./tests", destination: "/vagrant/tests"
    
        # copy config file
        override.vm.provision "file", source: "./.lidop_config.yaml", destination: "/vagrant/.lidop_config.yaml"

        # worker 0 is the master
        if worker == 0
  
            # adapt script for master installation
            script = <<-SCRIPT
                export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                export PUBLIC_IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
                if [[ $PUBLIC_IPADDRESS = *"404 - Not Found"* ]]; then export PUBLIC_IPADDRESS=$IPADDRESS; fi
                #{ansible_script}
                node=master 
                #{ENV['LIDOP_ENV']}'
            SCRIPT
            override.vm.provision "shell", inline: script

            # adapt script for master testing
            test = <<-SCRIPT
                export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                export TEST_HOST=master
                #{test_script}
            SCRIPT
            override.vm.provision "shell", inline: test

        elsif

            # adapt script for node installation
            # TBD:    # consul_ip=#{ipaddress_template}0
                script = <<-SCRIPT
                export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                export PUBLIC_IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
                if [[ $PUBLIC_IPADDRESS = *"404 - Not Found"* ]]; then export PUBLIC_IPADDRESS=$IPADDRESS; fi
                #{ansible_script}
                node=worker
                #{ENV['LIDOP_ENV']}'
                SCRIPT
            override.vm.provision "shell", inline: script
  
            # adapt script for node testing
            test = <<-SCRIPT
                export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
                export TEST_HOST=node
                #{test_script}
            SCRIPT
            override.vm.provision "shell", inline: test
        end

    end
end