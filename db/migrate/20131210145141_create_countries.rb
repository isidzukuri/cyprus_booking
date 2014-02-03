class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :code
      t.string :name_ru
      t.string :name_en
      t.string :name_uk
      t.string :country_phone
    end
  end
end
