class CarsSearch
  include ActiveAttr::Model
  include ActiveAttrAdditions::Relations

  attribute :same_place,  :type  => Integer, :default => 1
  attribute :confirm_age, :type  => Integer, :default => 1
  attribute :driver_age,  :type  => Integer, :default => 0
  nested_attribute :pick_up,   :class_name => "CarsLocation"
  nested_attribute :dropp_off, :class_name => "CarsLocation"

  validates_associated :pick_up,:dropp_off

  def interval
  	(self.pick_up.date..self.dropp_off.date).count - 1
  end

  def to_title
   "#{self.pick_up.country},#{self.pick_up.city} #{self.pick_up.date.strftime('%d.%m.%Y')}-#{self.dropp_off.date.strftime('%d.%m.%Y')}"
  end

end
