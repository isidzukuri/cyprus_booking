class CreateHDocs < ActiveRecord::Migration
  def up
    create_table :hotel_docs do |t|
      t.integer :adult
      t.integer :child
      t.string :first_name
      t.string :last_name
      t.integer :bed_type
      t.string :bed_type_desc
      t.string :smoking_pref
      t.string :conf_number
      t.integer :hotel_booking_payed_id
      t.boolean :canceled,:default =>false
      t.string :canceled_rooms

      t.timestamps
    end
  end

  def down
  end
end
