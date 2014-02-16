class CreateCarCities < ActiveRecord::Migration
  def change
    create_table :car_cities do |t|
      t.string :name
      t.string :lang
      t.integer :country_id

      t.timestamps
    end
  end
end
