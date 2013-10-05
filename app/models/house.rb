class House < ActiveRecord::Base

  has_one :user
  has_one :city
  has_many :photos
  has_and_belongs_to_many :facilities

  has_many :ratings
  has_many :characteristics, :through => :ratings
  # has_and_belongs_to_many :houses

  # validates :first_name,:last_name, :patronic, :city, :street,  :presence => {:message=>I18n.t("user.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("user.errors.minimum_chars")}
  # validates :building, :presence => true
  # validates :email, :uniqueness => {:message=>I18n.t("user.errors.email_registered")}, :format => {:message=>I18n.t("user.errors.wrong_email"),:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}

  

end
