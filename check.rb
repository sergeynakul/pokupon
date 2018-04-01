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

path = File.expand_path(".")

site1 = 'https://pokupon.ua/'
site2 = 'https://partner.pokupon.ua/'
sites = [site1, site2]

sites.each do |site|
	old_status = File.read("#{path}/status#{sites.index(site)}.txt").chomp
	response = Faraday.get site
	File.open("#{path}/status#{sites.index(site)}.txt", 'w') { |file| file.write("#{response.status}") }

	if response.status != 200 && response.status != old_status
		Mail.deliver do
		  from    'ror.test.e@gmail.com'
		  to      'nakul.sv@gmail.com'
		  subject site
		  body    "Status - #{response.status}. Error - " # как указать ошибку
		end
	end

	# для тестирования
	if response.status == 200
		Mail.deliver do
		  from    'ror.test.e@gmail.com'
		  to      'nakul.sv@gmail.com'
		  subject site
		  body    "Status - #{response.status}."
		end
	end
end
