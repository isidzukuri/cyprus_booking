class CreateCarsPayed < ActiveRecord::Migration
  def up
    create_table :cars_bookings_payeds do |t|
      t.string :reservation_id
      t.integer :vehicle_id
      t.string :car_name
      t.float :base_price
      t.integer :protect
      t.string :protect_price
      t.string :pick_country
      t.string :pick_city
      t.string :pick_place
      t.string :pick_location
      t.date :pick_date
      t.string :pick_time
      t.string :drop_country
      t.string :drop_city
      t.string :drop_place
      t.string :drop_location
      t.date :drop_date
      t.string :drop_time
      t.string :driver_name
      t.string :driver_surname
      t.string :driver_birthday
      t.text :cars_extras
      t.integer :user_id
      t.integer :car_location  
      t.integer :status    
      t.timestamps
    end
    add_index :cars_bookings_payeds, :user_id
  end

  def down
  end
end
