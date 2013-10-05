class AddStatusToPenalties < ActiveRecord::Migration
  def change
    add_column :penalties, :status, :integer
  end
end
