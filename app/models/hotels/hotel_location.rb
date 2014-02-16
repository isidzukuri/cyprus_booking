class HotelLocation < ActiveRecord::Base
  attr_accessible :code, :lat, :lng, :name,:country_id,:lang

  def to_map
  	{
  		lat:self.lat,
  		lng:self.lng,
  		id:self.id,
  		name:self.name,
  	}
  end
end
