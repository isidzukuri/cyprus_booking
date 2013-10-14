class House < ActiveRecord::Base
  attr_accessible :id, :user_id, :active, :name_ru, :name_uk, :name_en, :description_ru, :description_uk, :description_en, :cost, :full_address, :flat_number, :floor_number, :house_number, :street, :floors, :rooms, :places, :showers, :city_id, :facilities, :latitude, :longitude, :currency_id

  belongs_to :user
  belongs_to :city
  belongs_to :currency
  has_many :photos
  has_many :employments
  has_many :house_prices
  has_and_belongs_to_many :facilities

  has_many :ratings
  has_many :characteristics, :through => :ratings



  def concerted_price total
    Exchange.convert(self.currency.title, $currency) * total
  end

  def period_price search
    total = 0.0
    specific_prices = self.house_prices.where("from_date >= ? AND to_date <= ?",search.arrival.to_time.to_i,search.departure.to_time.to_i).all 
    search.nights.times do |n|
      total += specific_prices.count >= (n+1) ? specific_prices[n].cost : self.cost
    end
    concerted_price(total)
  end

  def total_rating
    total = 0.0
    self.ratings.each{|r| total += (r.value * Rating.koef) }
    total
  end

  def description
    read_attribute("description_#{I18n.locale}")
  end

  def name
    read_attribute("name_#{I18n.locale}")
  end

  def to_search search
    {
      :id        => self.id,
      :rooms     => self.rooms,
      :places    => self.places,
      :rating    => total_rating,
      :price     => period_price(search),
      :latitude  => self.latitude,
      :longitude => self.longitude
    }
  end

  

end
