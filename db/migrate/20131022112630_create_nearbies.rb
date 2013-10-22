class CreateNearbies < ActiveRecord::Migration
  def change
    create_table :nearbies do |t|
      t.integer :house_id
      t.string :ico_file_name
      t.string :name_ru
      t.string :name_en
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
