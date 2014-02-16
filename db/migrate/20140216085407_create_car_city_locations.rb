class CreateCarCityLocations < ActiveRecord::Migration
  def change
    create_table :car_city_locations do |t|
      t.string :name
      t.string :lang
      t.integer :country_id
      t.integer :car_city_id
      t.integer :location_id

      t.timestamps
    end
  end
end
