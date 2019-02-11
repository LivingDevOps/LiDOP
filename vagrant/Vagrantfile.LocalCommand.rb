require 'net/http'
require "open3"
module LocalCommand
    class Config < Vagrant.plugin("2", :config)
        attr_accessor :message
    end

    class Plugin < Vagrant.plugin("2")
        name "show_info"

        config(:show_info, :provisioner) do
            Config
        end

        provisioner(:show_info) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)
        def provision
            base_url, s1 = Open3.capture2 "vagrant ssh lidop_0 -c 'echo $(curl --silent consul.service.lidop.local:8500/v1/kv/config/base_url?raw)'"
            secret_password, s2 = Open3.capture2 "vagrant ssh lidop_0 -c 'echo $(curl --silent consul.service.lidop.local:8500/v1/kv/config/secret_password?raw)'"
            root_user, s2 = Open3.capture2 "vagrant ssh lidop_0 -c 'echo $(curl --silent consul.service.lidop.local:8500/v1/kv/config/root_user?raw)'"
            print("\n#############################################################\n" \
                    "LiDOP ist ready to use. \n" \
                    "#############################################################\n" \
                    "Access under: #{base_url}" \
                    "User: #{root_user}" \
                    "Password: the Password you entered on startup\n" \
                    "Secret Password: #{secret_password}" \
                    "#############################################################\n"
            )
        end
    end
end