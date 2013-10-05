class Rating < ActiveRecord::Base
  authenticates_with_sorcery!

  belongs_to :house
  belongs_to :characteristic

end
