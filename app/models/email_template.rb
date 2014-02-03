class EmailTemplate < ActiveRecord::Base
  attr_accessible :email_type, :html, :name
end
