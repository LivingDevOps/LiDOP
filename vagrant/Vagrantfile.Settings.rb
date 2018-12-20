require 'yaml'
require 'fileutils'

class Settings
    attr_accessor :user_name
    attr_accessor :password

    def initialize()
    end

    def init()

        if((ENV["USERNAME"] || "") != "")
            puts "Read username from ENV: #{ENV["USERNAME"]}"     
            @user_name = ENV["USERNAME"]   
        else
            print "Enter User: [lidop]: "
            @user_name = STDIN.gets.chomp
    
            if(@user_name == "")
                @user_name = "lidop"
            end
        end

        if((ENV["PASSWORD"] || "") != "")
            puts "Read password from ENV"     
            @password = ENV["PASSWORD"]
        else
            print "Enter Password (the Password is not anywhere saved encrypted): [lidop]: "
            @password = STDIN.noecho(&:gets).chomp
            print "\n"    

            print "Reenter Password: [lidop]: "
            @password2 = STDIN.noecho(&:gets).chomp
            print "\n"
            
            if(@password != @password2)
                raise 'Passwords are not same!!!!'  
            end

            if(@password == "")
                @password = "lidop"
            end
        end
    end

    def readConfig()
        config_file = "#{File.dirname(__FILE__)}/../.config.yaml"
        if((ENV["lidop_config"] || "") != "")
            puts "Use config file: #{config_file}"
            config_file = ENV["lidop_config"]
        end

        config = YAML.load_file(config_file)
        config.each do |key, value|
            value.each do |sub_key, sub_value|
                if((ENV["#{key}_#{sub_key}"] || "") != "")
                    puts "Read #{key} -> #{sub_key} from ENV"
                    config[key][sub_key] = ENV["#{key}_#{sub_key}"]
                end
            end
        end
        return config
    end

end
