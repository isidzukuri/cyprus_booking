class CreateApartmentsBookings < ActiveRecord::Migration
  def up
  	create_table :apartments_bookings do |t|
      t.integer :user_id
      t.integer :seller
      t.integer :from_date
      t.integer :to_date
      t.integer :total_cost
      t.integer :house_id
      t.timestamps
    end
  end

  def down
  end
end
