class CreateTravelers < ActiveRecord::Migration
  def change
    create_table :travelers do |t|
      t.integer :apartment_booking_id,:null=>false
      t.string :name
      t.string :email
      t.integer :gender,:default=>1
      t.integer :is_child ,:default=>0

      t.timestamps
    end
  end
end
