class ApartmentSearch
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  
  attribute :city_id,      :type => Integer
  attribute :city,         :type => String
  attribute :arrival,      :type => Date ,   :default => 1.week.from_now.to_date
  attribute :departure,    :type => Date ,   :default => 2.weeks.from_now.to_date
  attribute :people_count, :type => Integer, :default => 1

  # advanced
  attribute :price_from,   :type => Integer, :default => 0
  attribute :price_to,     :type => Integer, :default => 1000

  nested_attribute :facilities, :class_name => "Facility"

  def nights
    (arrival..departure).count - 1
  end

end
