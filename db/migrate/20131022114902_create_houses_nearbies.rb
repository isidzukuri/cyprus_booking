class CreateHousesNearbies < ActiveRecord::Migration
  def change
    create_table :houses_nearbies, :id => false do |t|
      t.references :house, :nearby
    end

    add_index :houses_nearbies, [:house_id, :nearby_id],
      name: "houses_nearbies_index",
      unique: true
  end
end
