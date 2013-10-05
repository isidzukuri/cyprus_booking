class Payment
  include ActiveAttr::Model 

  4.times do |i|
  	attribute :"card_number#{(i+1)}"
  end
  attribute :card_valid_m
  attribute :card_valid_y
  attribute :card_cvv
  attribute :card_holdername



  def number
  	str = ""
    4.times { |i| 	str << read_attribute("card_number#{(i+1)}") }
    str
  end

  def close_date
  	"#{self.card_valid_m}-#{self.card_valid_y}"
  end
end
