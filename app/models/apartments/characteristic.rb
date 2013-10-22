class Characteristic < ActiveRecord::Base
  attr_accessible :id, :active, :name_ru, :name_uk, :name_en

  has_many :ratings
  has_many :houses, :through => :ratings

  def name
    read_attribute("name_#{I18n.locale}")
  end
end
