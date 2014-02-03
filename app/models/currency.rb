class Currency < ActiveRecord::Base

  attr_accessible :id, :title, :curs ,:ico_file_name, :symbol
  has_attached_file :ico,
  	:url  => "/system/currencies/:id/:style.:extension",
    :path => ":rails_root/public/system/currencies/:id/:style.:extension", 
    :styles => {
	:small  => "35x35>"
	}
end
