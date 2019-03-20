
class Virtualbox

    def self.init(virtualbox, override, worker, settings, configuration, ansible_script, test_script)

        override.vm.box = configuration["virtualbox"]["#{configuration["install_mode"]}_box_name"]
        override.vm.box_url = configuration["virtualbox"]["#{configuration["install_mode"]}_box_url"]
        override.vm.box_version = configuration["virtualbox"]["#{configuration["install_mode"]}_box_version"]
        
        # Set Virtualbox configuration
        virtualbox.memory = configuration["virtualbox"]["memory"]
        virtualbox.cpus = configuration["virtualbox"]["cpus"]
        virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        
        # Set ipaddress of virtual machine
        ipaddress_template = configuration["virtualbox"]["ipaddress"]
        ipaddress = "#{ipaddress_template}#{worker}"
        override.vm.network :private_network, ip: "#{ipaddress}"

        # copy extra variables file
        override.vm.provision "file", source: "./.lidop_config.yaml", destination: "/vagrant/.lidop_config.yaml"

        # worker 0 is the master
        if worker == 0
            # forward ports (needed for accessing lidop over the guest ip machine)
            override.vm.network :forwarded_port, guest: 80, host: 80, auto_correct: true
            override.vm.network :forwarded_port, guest: 443, host: 443, auto_correct: true
            override.vm.network :forwarded_port, guest: 4243, host: 4243, auto_correct: true
            override.vm.network :forwarded_port, guest: 2377, host: 2377, auto_correct: true
            override.vm.network :forwarded_port, guest: 8301, host: 8301, auto_correct: true
            override.vm.network :forwarded_port, guest: 8500, host: 8500, auto_correct: true
            (8080..8099).each do |i|
                override.vm.network :forwarded_port, guest: i, host: i, auto_correct: true
            end

            # adapt script for master installation
            script = <<-SCRIPT
                #{ansible_script}
                node=master 
                ipaddress=#{ipaddress}
                public_ipaddress=#{ipaddress}
                #{ENV['LIDOP_ENV']}'
            SCRIPT
            override.vm.provision "shell", inline: script

            # adapt script for master testing
            test = <<-SCRIPT
                export IPADDRESS=#{ipaddress}
                export TEST_HOST=master
                #{test_script}
            SCRIPT
            override.vm.provision "shell", inline: test

        elsif
            # adapt script for node installation
            script = <<-SCRIPT
            export IPADDRESS=#{ipaddress}
            export PUBLIC_IPADDRESS=#{ipaddress}
                #{ansible_script}
                ipaddress=#{ipaddress}
                public_ipaddress=#{ipaddress}
                node=worker consul_ip=#{ipaddress_template}0
                #{ENV['LIDOP_ENV']}'
            SCRIPT
            override.vm.provision "shell", inline: script

            # adapt script for node testing
            test = <<-SCRIPT
                export IPADDRESS=#{ipaddress}
                export TEST_HOST=node
                #{test_script}
            SCRIPT
            override.vm.provision "shell", inline: test
        end      
    end
end