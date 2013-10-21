class Message < ActiveRecord::Base
  attr_accessible :user_id, :text, :status, :receiver

  belongs_to :user

end
