class House < ActiveRecord::Base
  attr_accessible :id, :user_id, :active, :name_ru, :name_uk, :name_en, :description_ru, :description_uk, :description_en, :cost, :full_address, :flat_number, :floor_number, :house_number, :street, :floors, :rooms, :places, :showers, :city_id, :facilities, :latitude, :longitude

  belongs_to :user
  belongs_to :city
  has_many :photos
  has_and_belongs_to_many :facilities

  has_many :ratings
  has_many :characteristics, :through => :ratings

  
  # has_and_belongs_to_many :houses

  # validates :first_name,:last_name, :patronic, :city, :street,  :presence => {:message=>I18n.t("user.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("user.errors.minimum_chars")}
  # validates :building, :presence => true
  # validates :email, :uniqueness => {:message=>I18n.t("user.errors.email_registered")}, :format => {:message=>I18n.t("user.errors.wrong_email"),:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  

end
