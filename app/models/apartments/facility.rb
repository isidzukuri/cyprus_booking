class Facility < ActiveRecord::Base

  attr_accessible :id, :active, :name_ru, :name_uk, :name_en, :seo ,:ico_file_name
  has_attached_file :ico,
  	:url  => "/system/facilities/:id/:style.:extension",
    :path => ":rails_root/public/system/facilities/:id/:style.:extension", 
    :styles => {
      :small  => "35x35>"
        }

  has_and_belongs_to_many :houses

  validates :name_uk,:name_ru, :name_en,   :presence => {:message=>I18n.t("facilities.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("facilities.errors.minimum_chars")}
  validates :seo, :uniqueness => {:message=>I18n.t("facilities.errors.not_unique")}, :format => {:message=>I18n.t("facilities.errors.wrong"),:with => /^[a-zA-Z0-9.-]+$/}

  def name
    read_attribute("name_#{I18n.locale}")
  end

end
