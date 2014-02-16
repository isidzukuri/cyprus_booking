class AddLatToCarCities < ActiveRecord::Migration
  def change
    add_column :car_cities, :lat, :float
    add_column :car_cities, :lng, :float
  end
end
