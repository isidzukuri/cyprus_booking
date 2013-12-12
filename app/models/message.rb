class Message < ActiveRecord::Base

  is_private_message

  attr_accessible :recipient_id, :sender_id, :body, :subject, :house_id
  
end