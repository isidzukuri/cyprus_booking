class Exchange
  
  class << self

	def convert from ,to
	  begin
	    koef = Rails.cache.fetch("#{from}#{to}", :expires_in => 1.month) do
			koef = exchanges(from,to)
			koef.nil? ? 1 : koef
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