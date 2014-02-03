class CreateHOtelLocation < ActiveRecord::Migration
  def change
    create_table :hotel_locations do |t|
      t.string :name
      t.integer :code
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end

