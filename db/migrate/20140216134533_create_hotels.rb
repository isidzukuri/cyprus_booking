class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.integer :hotel_id
      t.string :name
      t.string :address
      t.float :lat
      t.float :lng
      t.float :stars
      t.string :check_in
      t.string :check_out
      t.string :currency
      t.float :hight_rate
      t.float :low_rate

      t.timestamps
    end
  end
end
