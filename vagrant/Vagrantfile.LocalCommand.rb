
 require "open3"
require 'yaml'

module LocalCommand
    class Config < Vagrant.plugin("2", :config)
        attr_accessor :command
        attr_accessor :show
        attr_accessor :result
        attr_accessor :message
        attr_accessor :variable
        attr_accessor :args
    end

    class Plugin < Vagrant.plugin("2")
        name "local_shell"

        config(:local_shell, :provisioner) do
            Config
        end

        provisioner(:local_shell) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)
        def provision
            if(!File.exist?("#{File.dirname(__FILE__)}/../.temp.yaml")) 
                File.open("#{File.dirname(__FILE__)}/../.temp.yaml", "w") {|f| f.write("---\ntemp: dummy") }                
            end

            data = YAML.load_file("#{File.dirname(__FILE__)}/../.temp.yaml")

            if(config.command != nil)
                puts("run local command: #{config.command} #{config.args}")
                stdout, result = Open3.capture2 "#{config.command} #{config.args}"
                puts("set #{config.variable} to #{result}")
                data[config.variable] = stdout.strip
            end

            if(config.message != nil)
                puts("######################################################")
                print(config.message)
            end

            if(config.show != nil)
                puts(data[config.show])
                puts("######################################################")
            end

            if(config.result != nil)
                puts("add result")
                puts("set #{config.variable} to #{config.result}")
                data[config.variable] = config.result
            end

            File.open("#{File.dirname(__FILE__)}/../.temp.yaml", 'w') {|f| f.write data.to_yaml } #Store
        end
    end
end