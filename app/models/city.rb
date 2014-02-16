class City < ActiveRecord::Base
	attr_accessible :name,:lat,:lng

	def self.search term
		City.where("LOWER(name_ru) LIKE '#{term.downcase}%'").all
	end
	def name
	  read_attribute("name_#{I18n.locale}")
	end
	def name=(name)
	  write_attribute("name_#{I18n.locale}",name)
	end
    def to_map
  	  {
  		lat:self.lat,
  		lng:self.lng,
  		id:self.id,
  		name:self.name,
  	  }
    end
end
