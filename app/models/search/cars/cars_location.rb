class CarsLocation
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :country,  :type => String 
  attribute :city,     :type => String 
  attribute :location
  attribute :place
  attribute :date,      :type => Date ,   :default => 2.week.from_now.to_date.strftime("%d.%m.%Y")
  attribute :time,      :type => String ,:default=>"11-00"
  validates :location, :date, :time, :presence => true

end
