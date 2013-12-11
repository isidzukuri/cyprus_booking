class HotelRoom
  
   
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations
  attribute :id,        :type => Integer , :default => 1
  attribute :adults,    :type => Integer , :default => 2
  attribute :childs,    :type => Integer , :default => 0
  attribute :child_age, :type => Integer , :default => 12
  nested_attribute :adult, :class_name => "HotelAdult"
  nested_attribute :child, :class_name => "HotelChild"
  
  
  
  def count_adults
    self.adult.size
  end

  def count_childs
    self.child().size
  end
  
  def to_api_hash
    child   =  (1..self.childs).to_a.join(',')
    visitors = self.childs == 0 ? self.adults.to_s : self.adults.to_s + "," + child
  end
  

end
