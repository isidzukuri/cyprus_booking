class House < ActiveRecord::Base
  attr_accessible :id, :user_id, :active, :name_ru, :name_uk, :name_en, :description_ru, :description_uk, :description_en, :cost, :full_address, :flat_number, :floor_number, :house_number, :street, :floors, :rooms, :places, :showers, :city_id,:nearbies, :facilities, :latitude, :longitude, :currency_id

  belongs_to :user
  belongs_to :city
  belongs_to :currency
  has_many :photos
  has_many :employments
  has_many :house_prices
  has_many :rewievs
  has_many :wishes
  has_and_belongs_to_many :nearbies
  has_and_belongs_to_many :facilities

  has_many :ratings
  has_many :characteristics, :through => :ratings

  validates_presence_of :city_id, :full_address, :house_number, :street

  def concerted_price total
    Exchange.convert(self.currency.title, $currency) * total
  end

  def period_price search
    total = 0.0
    specific_prices = self.house_prices.where("from_date >= ? AND to_date <= ?",search.arrival.to_time.to_i,search.departure.to_time.to_i).all 
    search.nights.times do |n|
      total += specific_prices.count >= (n+1) ? specific_prices[n].cost : self.cost
    end
    concerted_price(total).to_i
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

  def address full = false
    "#{self.city_name} #{full ? ",#{street}" : ""} #{self.name}"
  end

  def default_cost_string
    "#{concerted_price(self.cost).round(1)}#{self.currency.symbol}"
  end


  def first_img
    return self.photos.present? ? self.photos.first.file.url(:cabinet) : ''
  end

  def city_name
    return self.city["name_#{I18n.locale}"]
  end

  def is_busy? search
    return false if busy_dates.nil?
    (search.departure..search.arrival).map do |d|
        busy_dates.include?(d.strftime("%e%-m%Y"))
     end.include?(true)
  end


  def busy_dates
    dates = []
    dates = self.employments.map do|price| 
      while price.to_date >= price.from_date
        dates << Time.at(price.from_date).strftime("%e%-m%Y")
        price.from_date += 1.day
      end
      dates
    end.flatten!    
  end

  def changed_prices
    data = [{:dates=>[],:price=>0}]
    data = self.house_prices.map do|price| 
    dates = []
     while price.to_date >= price.from_date
       dates << Time.at(price.from_date).strftime("%e%-m%Y")
       price.from_date += 1.day
     end
     {:dates=>dates,:price=>price.cost}
    end
  end

  def to_search search
    {
      :id        => self.id,
      :rooms     => self.rooms,
      :places    => self.places,
      :rating    => total_rating,
      :name      => self.name,
      :price     => period_price(search),
      :latitude  => self.latitude,
      :longitude => self.longitude,
      :img       => self.first_img,
      :city      => self.city_name,
    }
  end

  

end
