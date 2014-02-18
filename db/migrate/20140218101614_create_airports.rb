class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name_ru
      t.string :name_en
      t.string :code
      t.string :city
      t.string :country
    end
  end
end
