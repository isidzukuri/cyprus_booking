class Driver
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :name ,    :type => String 
  attribute :surname , :type => String 
  attribute :birthday_day , :type => Integer
  attribute :birthday_month , :type => Integer
  attribute :birthday_year , :type => Integer

end
