class Rewiev < ActiveRecord::Base
  attr_accessible :user_id, :house_id, :text
  belongs_to :house
  belongs_to :user
end
