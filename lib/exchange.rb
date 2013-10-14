class Exchange
  class << self
	def convert from ,to
	  begin
		koef = exchanges[from.to_sym][to.to_sym]
	  rescue
		koef = 1
	  ensure
		return koef
	end

	def exchanges
		{:USD=>{:EUR=>1,:UAH=>0.5,:RUR=>0.2}}
	end
  end
end