class HotelLocation < ActiveRecord::Base
  attr_accessible :code, :lat, :lng, :name,:country_id,:lang,:name_en,:name_ru,:country_id
  has_many :hotels
	def name
	  read_attribute("name_#{I18n.locale}")
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
