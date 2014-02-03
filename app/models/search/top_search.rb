class TopSearch
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :city,          :type => String
  attribute :code,          :type => String
  attribute :lat,           :type => Float
  attribute :lng,           :type => Float
  attribute :arrival,       :type => Date,    :default => 2.week.from_now.to_date.strftime("%d.%m.%Y")
  attribute :departure,     :type => Date,    :default => 1.weeks.from_now.to_date.strftime("%d.%m.%Y")
  attribute :rooms_count,   :type => Integer, :default => 1
  attribute :results_count, :type => Integer, :default => 200
  attribute :people_count,  :type => Integer, :default => 1
  nested_attribute :rooms,  :class_name => "HotelRoom"

end
