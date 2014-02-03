class ChangeTravelers < ActiveRecord::Migration
  def up
  	rename_column :travelers, :apartment_booking_id, :apartments_booking_id
  end

  def down
  end
end
