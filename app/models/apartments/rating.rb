class Rating < ActiveRecord::Base
  belongs_to :house
  belongs_to :characteristic

end
