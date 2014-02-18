class AviaSearch
  include ActiveAttr::Model
  attribute :from_name,  :type  => String
  attribute :to_name,  :type  => String
  attribute :origin_name,  :type  => String, :default => "MOW"
  attribute :destination_name, :type  => String, :default => "PFO"
  attribute :depart_date, :type => Date ,   :default => 2.week.from_now.to_date.strftime("%Y-%m-%d")
  attribute :return_date, :type => Date ,   :default => 3.week.from_now.to_date.strftime("%Y-%m-%d")
  attribute :range, :type  => Integer, :default => 0
  attribute :adults, :type  => Integer, :default => 1
  attribute :children, :type  => Integer, :default => 0
  attribute :infants, :type  => Integer, :default => 0
  attribute :trip_class, :type  => Integer, :default => 0
   attribute :same_place, :type  => Integer, :default => 1
  attribute :direct , :type  => Integer, :default => 1


  def interval
  	(self.return_date..self.depart_date).count - 1
  end

  def to_api_hash
    hash = self.attributes
    hash.delete("from_name")
    hash.delete("to_name")
    hash.delete("same_place")

    hash["depart_date"] = hash["depart_date"].strftime("%Y-%m-%d")
    hash["return_date"] = hash["return_date"].strftime("%Y-%m-%d")
    hash.delete("return_date") if self.same_place == 0
    hash
  end

  def to_title
   "#{self.from_name} &#10175; #{self.to_name} #{self.depart_date.strftime('%d.%m.%Y')} - #{self.return_date.strftime('%d.%m.%Y')}"
  end


end
