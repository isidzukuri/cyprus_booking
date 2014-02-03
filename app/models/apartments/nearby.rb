class Nearby < ActiveRecord::Base
  attr_accessible  :ico_file_name, :name_en, :name_ru
  has_and_belongs_to_many :houses

  has_attached_file :ico,
  	:url  => "/system/nearbies/:id/:style.:extension",
    :path => ":rails_root/public/system/nearbies/:id/:style.:extension", 
    :styles => {
      :small  => "35x35>"
        }

  def name
    read_attribute("name_#{I18n.locale}")
  end
end
