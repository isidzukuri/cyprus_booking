class AddImgUrlToHotelBookingPayeds < ActiveRecord::Migration
  def change
    add_column :hotel_booking_payeds, :img_url, :string
  end
end
