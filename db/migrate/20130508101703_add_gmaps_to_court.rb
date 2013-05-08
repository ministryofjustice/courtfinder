class AddGmapsToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :gmaps, :boolean
  end
end
