class AddLangToHotelLocations < ActiveRecord::Migration
  def change
    add_column :hotel_locations, :lang, :string
  end
end
