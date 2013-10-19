class AddStatustoApartmentsBookings < ActiveRecord::Migration
  def up
  	add_column :apartments_bookings, :status, :integer
  end

  def down
  end
end
