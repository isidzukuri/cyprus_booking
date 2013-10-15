class Exchange
  
  class << self

	def convert from ,to

	  begin
	  	unless koef = Rails.cache.read("#{from}#{to}")
			koef = exchanges from,to
			koef  = koef.nil? ? 1 : koef
			Rails.cache.write("#{from}#{to}",koef,:expires_in => 12.hours)
		end
	  rescue
		koef = 1
	  ensure
		return koef
	  end
	end

	def exchanges from,to
		url  = "http://rate-exchange.appspot.com/currency".to_uri
		data = url.get(:from=>from,:to=>to).deserialise["rate"]
	end
  end
end