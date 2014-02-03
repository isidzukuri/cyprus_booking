class Country < ActiveRecord::Base
  attr_accessible :code, :name_en, :name_ru, :name_uk, :country_phone

  def name
    read_attribute("name_#{I18n.locale}")
  end
  def to_phone_list
  	["+#{self.country_phone}",self.country_phone]
  end
  
  def to_nationaliti_list
  	[self.name,self.code]
  end

  def self.get_phones
  	Country.where("country_phone != ''").order("country_phone asc").all.map(&:to_phone_list).uniq
  end
end
