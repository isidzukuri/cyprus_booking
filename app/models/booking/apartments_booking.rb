class ApartmentsBooking < ActiveRecord::Base
  attr_accessible :id, :user_id, :seller, :house_id, :total_cost, :from_date, :to_date, :status,:travelers,:currency

  belongs_to :house
  belongs_to :user
  has_many   :travelers
  before_save :set_status

  # statuses
  # 1 - unpayed
  # 2 - payed
  # 3 - canceled

  def first_img
  	return self.house.photos.present? ? self.house.photos.first.file.url(:cabinet) : ''
  end
  def set_status
    self.status = 1
    
  end

  def city_name
  	return self.house.city["name_#{I18n.locale.to_s}".to_sym]
  end

  def address
  	return self.house.full_address
  end

  def from
  	return Time.at(self.from_date).strftime('%d.%m.%Y')
  end

  def to
  	return Time.at(self.to_date).strftime('%d.%m.%Y')
  end

  def show_total_cost
    return Exchange.convert(self.currency, $currency) * self.total_cost
  end

end
