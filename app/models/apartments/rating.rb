class Rating < ActiveRecord::Base
  belongs_to :house
  belongs_to :characteristic

  def koef
  	0.01
  end

end
