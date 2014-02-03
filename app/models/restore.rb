class Restore
  apply_simple_captcha
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :email,    :type => String 

  
end