class CarsLocation
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :country,  :type => String 
  attribute :city,     :type => String 
  attribute :location
  attribute :place
  attribute :date,      :type => Date 
  attribute :time,      :type => String 
  validates :location, :date, :time, :presence => true

end
