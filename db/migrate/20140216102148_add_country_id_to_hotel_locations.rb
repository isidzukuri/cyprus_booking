class AddCountryIdToHotelLocations < ActiveRecord::Migration
  def change
    add_column :hotel_locations, :country_id, :integer
  end
end
