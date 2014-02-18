class Airport < ActiveRecord::Base
  attr_accessible :city, :code, :country, :name_en, :name_ru
	def name
	  read_attribute("name_#{I18n.locale}")
	end

	def self.search iata
		Airport.where("code = ? OR city= ?",iata,iata).first.name
	end

end
