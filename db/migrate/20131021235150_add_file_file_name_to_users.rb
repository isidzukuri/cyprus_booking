class AddFileFileNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :file_file_name, :string
  end
end
