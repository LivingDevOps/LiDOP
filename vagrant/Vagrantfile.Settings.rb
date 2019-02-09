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
            print "Enter Password: [lidop]: "
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
        lidop_config_file = "#{File.dirname(__FILE__)}/../.lidop_config.yaml"
        if((ENV["lidop_config"] || "") != "")
            puts "Use config file: #{lidop_config_file}"
            lidop_config_file = ENV["lidop_config"]
        end

        vagrant_config_file = "#{File.dirname(__FILE__)}/../.vagrant_config.yaml"
        if((ENV["vagrant_config"] || "") != "")
            puts "Use config file: #{vagrant_config_file}"
            vagrant_config_file = ENV["vagrant_config"]
        end

        lidop_config = YAML.load_file(lidop_config_file)
        vagrant_config = YAML.load_file(vagrant_config_file)
        config = lidop_config.merge!(vagrant_config)
        config.each do |key, value|
            if((ENV["#{key}"] || "") != "")
                puts "Read #{key} from ENV"
                config[key] = ENV["#{key}"]
            end
        end
        return config
    end

end
