class AddNameRuToHotelLocations < ActiveRecord::Migration
  def change
    add_column :hotel_locations, :name_ru, :string
    add_column :hotel_locations, :name_en, :string
  end
end
