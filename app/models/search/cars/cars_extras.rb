class CarsExtras
  
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :id ,    :type => Integer 
  attribute :name ,  :type => String 
  attribute :price 
  attribute :day_price
  attribute :count , :type => Integer , :default => 0
  validates :count , :presence => true

  def franchize
  	11068872371010
  end

end
