class AddHotelLocationIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :hotel_location_id, :integer
    add_column :hotels, :image_url, :string
  end
end
