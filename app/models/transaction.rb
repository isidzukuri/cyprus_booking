class Transaction < ActiveRecord::Base
  attr_accessible  :id, :penalty_id, :user_attributes,:penalty_attributes, :status, :created_at,:amount, :total_amount, :user_id, :commision , :system
  belongs_to :user
  belongs_to :penalty


end
