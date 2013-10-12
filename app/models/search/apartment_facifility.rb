class ApartmentFacifility
  include ActiveAttr::Model
  
  attribute :id,          :type => Integer
  attribute :name,        :type => String
  attribute :active,      :type => Integer ,   :default => 0

end
