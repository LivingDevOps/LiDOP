require 'json'
require 'securerandom'
require 'time'
require 'net/http'
require 'uri'

$error = false

$uuid = SecureRandom.uuid 

$out_file = File.new(".debug.log", 'w')
$out_file.flush

def $stdout.write message
    if message.gsub(/\r?\n/, "") != ''
        date = ::Time.now
        append "info", date.utc.iso8601(6), message
        
        date_string=date.strftime("%d.%m.%Y %T")
        message=date_string + " " + message.gsub(/\r\n/, "\n")
    end
    super message
end

def $stderr.write message
    $error = true
    if message.gsub(/\r?\n/, "") != ''
        date = ::Time.now
        append "error", date.utc.iso8601(6), message
        
        date_string=date.strftime("%d.%m.%Y %T")
        message=date_string + " " + message.gsub(/\r\n/, "\n")
    end
    super message
end

def append type, date_string, message

    tempHash = {
        "@timestamp" => date_string, 
        "uuid" => $uuid, 
        "log_type" => type, 
        "message" => message.encode('utf-8', 'binary', :undef => :replace)
    }
    
    $out_file.write JSON.generate(tempHash) + "\n"
    $out_file.flush

end

at_exit do

    if ($error)


        if((ENV["SENDERROR"] || "") != "")
            puts "Read senderror from ENV: #{ENV["SENDERROR"]}"     
            @send = ENV["SENDERROR"]   
        else
            print "Send the Error to the LiDOP team: [yes]: "
            @send = STDIN.gets.chomp
        end

        if(@send == "" || @send == "yes")
    
            uri = URI.parse("http://listener.logz.io:8070?token=BQTJyzLDjFyGIvvnBfoVRRWSlojJQfBE&type=http_bulk")
            request = Net::HTTP::Post.new(uri)
            request.body = ""
            request.body << File.read(".debug.log")
            req_options = {
                use_ssl: uri.scheme == "https",
            }
    
            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end
            puts "Result: #{response.code}"    
        end
    end
end
