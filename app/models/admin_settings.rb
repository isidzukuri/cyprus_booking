class AdminSettings < ActiveRecord::Base
  attr_accessible :setting, :value
end
