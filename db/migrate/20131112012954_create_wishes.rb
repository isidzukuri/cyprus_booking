class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.integer :user_id
      t.integer :house_id

      t.timestamps
    end
    add_index :wishes, :user_id
    add_index :wishes, :house_id
  end
end
