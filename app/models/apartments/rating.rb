class Rating < ActiveRecord::Base
  belongs_to :house
  belongs_to :characteristic

  def self.koef
  	0.5
  end

end
