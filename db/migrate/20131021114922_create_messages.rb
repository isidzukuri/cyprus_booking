class CreateMessages < ActiveRecord::Migration
  def up
  	create_table :messages do |t|
      t.integer :user_id
      t.integer :receiver
      t.integer :status
      t.text :text
      t.string :text
      t.timestamps
    end
  end

  def down
  end
end
