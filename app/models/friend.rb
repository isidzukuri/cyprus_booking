class Friend < ActiveRecord::Base
  attr_accessible :user_id, :friend_id, :status

  belongs_to :user


  def friend_data
    User.find(self.friend_id)
  end


end
