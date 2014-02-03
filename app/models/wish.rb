class Wish < ActiveRecord::Base
  attr_accessible :house_id, :user_id
  belongs_to :user
  belongs_to :house
end
