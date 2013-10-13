class City < ActiveRecord::Base
	attr_accessible :name_ru

	def self.search term
		City.where("LOWER(name_ru) LIKE '#{term.downcase}%'").all
	end
end
