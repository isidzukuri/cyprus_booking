class HotelLocation < ActiveRecord::Base
  attr_accessible :code, :lat, :lng, :name
end
