class Photo < ActiveRecord::Base
	belongs_to :house

	has_attached_file :file, 
	:url  => "/photos_houses/:house_id/:id/:style.:extension",
    :path => ":rails_root/public/photos_houses/:house_id/:id/:style.:extension",    
	:styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['220x100#',   :jpg],
      :medium   => ['450x285',    :jpg],
      :large    => ['500x500>',   :jpg]
  	}

	Paperclip.interpolates :house_id do |attachment, style|
		"#{attachment.instance.house_id}"
	end


end
