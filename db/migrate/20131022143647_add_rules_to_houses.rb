class AddRulesToHouses < ActiveRecord::Migration
  def change
    add_column :houses, :rules, :string
  end
end
