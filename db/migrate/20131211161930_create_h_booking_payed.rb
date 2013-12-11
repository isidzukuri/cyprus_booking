class CreateHBookingPayed < ActiveRecord::Migration
  def up
     create_table :hotel_booking_payeds do |t|
      t.integer :user_id
      t.string :sesion_id
      t.string :reservation_id
      t.string :conf_numbers
      t.boolean :with_confirmation
      t.string :s_type
      t.string :status
      t.boolean :reservation_exist
      t.string :rooms
      t.text :checkin_inst
      t.string :arrival_date
      t.string :departure_date
      t.string :hotel_name
      t.string :hotel_address
      t.string :room_desc
      t.text :cancel_policy
      t.boolean :non_refunable
      t.string :occupancy_pre_room
      t.string :total_price
      t.string :price_per_night
      t.string :rooms_adt
      t.string :rooms_chd
      t.string :rooms_names
      t.boolean :canceled,:default =>false

      t.timestamps
  	end
  end

  def down
  end
end
