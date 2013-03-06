class AddIndexToCourts < ActiveRecord::Migration
  def change
    add_earthdistance_index :courts, {:lat => 'latitude', :lng => 'longitude'}
  end
end
