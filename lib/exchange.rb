class Exchange
  
  class << self

	def convert from ,to
	  begin
		koef = exchanges from,to
		koef koef.ni? ? 1 : koef
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