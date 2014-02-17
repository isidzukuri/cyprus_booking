class Api::Avia

	def initialize settings
		@settings = settings
	end

	def complete term
		@settings.complete_url.to_uri.get(locale:locale,term:term).deserialize.map do |i|
			{:code=>i["iata"],:value=>i["name"]}
		end
	end

	def search hash
		@settings.search_url.to_uri.post_form(params(hash)).deserialize
	end

	def book_url
		@book_url ||= Proc.new{|search_id,order_url_id| "http://nano.aviasales.ru/searches/#{search_id}/order_urls/#{order_url_id}?marker=#{@settings.marker}"}
	end

	private
	def sign search
		Digest::MD5.hexdigest([@settings.token, @settings.marker, *search.values_at(*search.keys.sort)].join(':'))
	end

	def params hash
		data = {   
			"locale"          => locale,
			"enable_api_auth" => false,
			"signature"       => sign(hash),
			"search[marker]"  => @settings.marker,
		}
		hash.each_pair{ |k,v| data.merge!({"search[params_attributes][#{k}]"=>v}) }
		data
	end

	def locale
		%w(ru en de).include?(I18n.locale) ? I18n.locale : :en
	end
  
end