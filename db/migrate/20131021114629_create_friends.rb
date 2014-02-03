class CreateFriends < ActiveRecord::Migration
  def up
  	create_table :friends do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :status
      t.timestamps
    end
  end

  def down
  end
end
