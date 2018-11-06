
# class Azure
#     def self.init(azure, override, worker, settings, configuration, ansible_script, test_script)

#         ENV['VAGRANT_NO_PARALLEL'] = 'yes'

#         override.ssh.private_key_path = '~/.ssh/id_rsa'
#         # override.ssh.insert_key = false

#         override.vm.box = 'azure'

#         azure.tenant_id = configuration["azure"]["azure_tenant_id"]
#         azure.client_id = configuration["azure"]["azure_client_id"]
#         azure.client_secret = configuration["azure"]["azure_client_secret"]
#         azure.subscription_id = configuration["azure"]["azure_subscription_id"]

#         azure.vm_size = configuration["azure"]["azure_subscription_id"] "Standard_B2s"
#         azure.resource_group_name = configuration["azure"]["azure_subscription_id"] "Vagrant_Resource_Group"
#         azure.location = configuration["azure"]["azure_subscription_id"] "westeurope"
#         azure.vm_name =  "ADOlight"
#         azure.vm_password = ""
#         azure.admin_username = ""
#     #    azure.virtual_network_name =""
#         azure.dns_name = "lidop"
#     #    azure.nsg_name =""
#     #    azure.subnet_name =""

#         azure.tcp_endpoints = ["8080-8090", "9418"]

#         azure.vm_image_urn = "Canonical:UbuntuServer:16.04-LTS:latest"
#         azure.wait_for_destroy = true

#         override.vm.synced_folder ".", "/vagrant", disabled: true

#         override.vm.provision "shell", inline: "mkdir -p /vagrant"
#         override.vm.provision "shell", inline: "chmod 777 -R /vagrant"
#         override.vm.provision "file", source: "./configs", destination: "/vagrant/configs"
#         override.vm.provision "file", source: "./install", destination: "/vagrant/install"
#         override.vm.provision "file", source: "./plugins", destination: "/vagrant/plugins"

#         override.vm.provision "shell", path: "./scripts/vagrant.sh"
#         override.vm.provision "shell", path: "./scripts/ansible.sh"

#         if worker == 0
#             File.open(".swarm_master_ip", "a").close()
#             File.open(".swarm_worker_token", "a").close()

#             $script = <<-SCRIPT
#             export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
#             export PUBLIC_IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
#             export lidop_EXTEND=#{ENV['lidop_EXTEND_NEW']}
#             export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg
#             ansible-playbook -v /vagrant/install/install.yml -e ' 
#                 root_password=#{settings.password}
#                 root_user=#{settings.user_name}
#                 install_mode=#{settings.install_mode}
#                 node=master #{ENV['LIDOP_ENV']}'
#             SCRIPT
            
#             override.vm.provision "shell", inline: $script

#             override.vm.provision "readSwarmMaster", type: "local_shell", file: ".swarm_master_ip", command: "vagrant ssh -c \"curl -s http://169.254.169.254/latest/meta-data/local-ipv4\""
#             override.vm.provision "readSwarmToken", type: "local_shell", file: ".swarm_worker_token", command: "vagrant ssh -c \"sudo docker swarm join-token -q worker\""
#         elsif
#             $script = <<-SCRIPT
#             export IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
#             export PUBLIC_IPADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
#             export lidop_EXTEND=#{ENV['lidop_EXTEND_NEW']}
#             export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg
#             ansible-playbook -v /vagrant/install/install.yml -e '\
#                 root_password=#{settings.password} \
#                 root_user=#{settings.user_name} \
#                 install_mode=#{settings.install_mode} \
#                 node=worker #{ENV['LIDOP_ENV']}'
#             SCRIPT

#             override.vm.provision "file", source: "./.swarm_master_ip", destination: "/vagrant/.swarm_master_ip"
#             override.vm.provision "file", source: "./.swarm_worker_token", destination: "/vagrant/.swarm_worker_token"
#             override.vm.provision "shell", inline: $script
#         end

#     end
# end