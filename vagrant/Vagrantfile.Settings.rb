class Settings
    attr_accessor :user_name
    attr_accessor :password

    def initialize()
    end

    def init1()

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
end
