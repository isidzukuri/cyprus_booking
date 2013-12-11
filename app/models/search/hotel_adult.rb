class HotelAdult

  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :first_name,    :type => String 
  attribute :last_name,     :type => String 
  attribute :birth_day,     :type => Integer 
  attribute :birth_month,   :type => Integer 
  attribute :birth_year,    :type => Integer 

  
  def to_api_hash
    hash = {
      :FirstName => self.first_name,
      :LastName  => self.last_name
    }
  end
  
end