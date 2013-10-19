class ApartmentsBooking < ActiveRecord::Base
  attr_accessible :id, :user_id, :seller, :house_id, :total_cost, :from_date, :to_date, :status

  belongs_to :house
  belongs_to :user

  def first_img
  	return self.house.photos.first
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

end
