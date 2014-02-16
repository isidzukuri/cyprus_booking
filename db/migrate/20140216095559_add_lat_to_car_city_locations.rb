class AddLatToCarCityLocations < ActiveRecord::Migration
  def change
    add_column :car_city_locations, :lat, :float
    add_column :car_city_locations, :lng, :float
  end
end
