class AddLatLngToCities < ActiveRecord::Migration
  def change
    add_column :cities, :lat, :float
    add_column :cities, :lng, :float
  end
end
