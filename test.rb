
require 'whenever'
require 'mail'
require 'faraday'

Mail.defaults do
  delivery_method :smtp, 
  address:        "smtp.gmail.com",
  port:           587,
  domain:         "localhost",
  authentication: "plain",
  user_name:      "ror.test.e@gmail.com",
  password:       "ror123456789",
  enable_starttls_auto: true
end

old_status = File.read("/home/newHomeDir/rails/ruby/pokupon/status.txt").chomp

response = Faraday.get 'https://pokupon.ua/'

File.open('/home/newHomeDir/rails/ruby/pokupon/status.txt', 'w') { |file| file.write("#{response.status}") }

if response.status != 200 && response.status != old_status
	Mail.deliver do
	  from    'ror.test.e@gmail.com'
	  to      'nakul.sv@gmail.com'
	  subject 'Response status'
	  body    "Status - #{response.status}. Error - " # как указать ошибку
	end
elsif response.status == 200 && response.status != old_status
	Mail.deliver do
	  from    'ror.test.e@gmail.com'
	  to      'nakul.sv@gmail.com'
	  subject 'Response status'
	  body    "Status - #{response.status}. Error - "
	end
end