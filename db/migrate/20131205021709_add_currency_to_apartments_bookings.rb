class AddCurrencyToApartmentsBookings < ActiveRecord::Migration
  def change
    add_column :apartments_bookings, :currency, :string
  end
end
