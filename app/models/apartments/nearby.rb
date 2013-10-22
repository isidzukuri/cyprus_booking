class Nearby < ActiveRecord::Base
  attr_accessible :house_id, :ico_file_name, :lat, :lng, :name_en, :name_ru
  belongs_to :house
end
