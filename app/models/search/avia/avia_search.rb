class AviaSearch
  include ActiveAttr::Model

  attribute :origin_name,  :type  => String, :default => "MOW"
  attribute :destination_name, :type  => Integer, :default => "PFO"
  attribute :depart_date, :type => Date ,   :default => 2.week.from_now.to_date.strftime("%Y-%m-%d")
  attribute :return_date, :type => Date ,   :default => 3.week.from_now.to_date.strftime("%Y-%m-%d")
  attribute :range, :type  => Integer, :default => 0
  attribute :adults, :type  => Integer, :default => 1
  attribute :children, :type  => Integer, :default => 0
  attribute :infants, :type  => Integer, :default => 0
  attribute :trip_class, :type  => Integer, :default => 0


  def interval
  	(self.return_date..self.depart_date).count - 1
  end

  def to_title
   "#{self.pick_up.country},#{self.pick_up.city} #{self.return_date.strftime('%d.%m.%Y')}-#{self.depart_date.strftime('%d.%m.%Y')}"
  end


end
