class Api::Avia

	attr_accessor :locale

	def initialize settings
		@locale   = :ru
		@settings = settings
	end

	def complete term
		@settings.complete_url.to_uri.get(locale:@locale,term:term)
	end

	def search hash
		@settings.search_url.get(hash).deserialize
	end
  
end