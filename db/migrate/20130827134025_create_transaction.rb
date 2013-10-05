class CreateTransaction < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :status,  :null=>false, :default => 1
      t.integer :system,  :null=>false, :default => 1
      t.string  :amount,  :null=>false, :default => 0
      t.string  :total_amount,  :null=>false, :default => 0
      t.string  :commision,  :null=>false, :default => 0
      t.integer :user_id,  :null=>false
      t.integer :penalty_id,  :null=>false
      t.timestamps
    end
    add_index :transactions, :user_id
    add_index :transactions, :penalty_id
    add_index :transactions, :status
  end

  def self.down
    remove_index :transactions, :user_id
    remove_index :transactions, :penalty_id
    drop_table :transactions
  end
end
