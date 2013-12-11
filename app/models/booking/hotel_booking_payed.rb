class HotelBookingPayed < ActiveRecord::Base
  belongs_to :user

  has_many :hotel_doc
  attr_accessible :img_url, :rooms_chd, :rooms_adt, :rooms_names,:arrival_date, :cancel_policy, :checkin_inst, :conf_numbers, :departure_date, :hotel_address, :hotel_name, :non_refunable, :occupancy_pre_room, :price_per_night, :reservation_exist, :reservation_id, :room_desc, :room_type, :rooms, :s_type, :sesion_id, :status, :total_price, :user_id, :with_confirmation

  def show_total_cost
    return Exchange.convert(self.currency, $currency) * self.total_price.to_f
  end

  def currency
  	"EUR"
  end

end
