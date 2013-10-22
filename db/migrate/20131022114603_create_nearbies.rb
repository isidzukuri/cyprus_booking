class CreateNearbies < ActiveRecord::Migration
  def change
    create_table :nearbies do |t|
      t.string :ico_file_name
      t.string :name_ru
      t.string :name_en
      t.string :distance
      t.timestamps
    end
  end
end
