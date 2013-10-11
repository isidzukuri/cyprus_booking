class House < ActiveRecord::Base
  attr_accessible :id, :user_id, :active, :name_ru, :name_uk, :name_en, :description_ru, :description_uk, :description_en, :cost, :full_address, :flat_number, :floor_number, :house_number, :street, :floors, :rooms, :places, :showers, :city_id, :facilities, :latitude, :longitude

  belongs_to :user
  belongs_to :city
  has_many :photos
  has_many :employments
  has_and_belongs_to_many :facilities

  has_many :ratings
  has_many :characteristics, :through => :ratings

  

end
