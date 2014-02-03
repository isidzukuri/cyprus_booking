class AddHouseIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :house_id, :integer
  end
end
