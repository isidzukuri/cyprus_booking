class ChangeDescriptionTypeForHouses < ActiveRecord::Migration
  def up
   change_column :houses, :description_ru, :text
   change_column :houses, :description_uk, :text
   change_column :houses, :description_en, :text
  end

  def down
   change_column :houses, :description_ru, :string
   change_column :houses, :description_uk, :string
   change_column :houses, :description_en, :string
  end
end
