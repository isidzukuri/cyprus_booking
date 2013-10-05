class Bank < ActiveRecord::Base
  attr_accessible  :bank_code, :name_ru, :name_ua
  has_many :payment_details
  validates :bank_code,:name_ru, :name_ua, :presence => {:message=>I18n.t("user.errors.presense")}, :length => {:minimum => 3, :maximum => 254 ,:message=>I18n.t("user.errors.minimum_chars")}

  def name
    read_attribute("name_#{I18n.locale}")    
  end  

end
