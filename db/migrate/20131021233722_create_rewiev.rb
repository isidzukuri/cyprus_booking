class CreateRewiev < ActiveRecord::Migration
  def up
  	create_table :rewievs do |t|
      t.integer :user_id
      t.integer :house_id
      t.integer :status
      t.string  :text
      t.timestamps
    end
  end

  def down
  end
end
