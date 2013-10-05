class Characteristic < ActiveRecord::Base
  attr_accessible :name_ru, :name_uk, :name_en

  has_many :ratings
  has_many :houses, :through => :ratings

end
