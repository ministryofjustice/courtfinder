class AddLeafletsToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :info_leaflet, :text
    add_column :courts, :defence_leaflet, :text
    add_column :courts, :prosecution_leaflet, :text
    add_column :courts, :juror_leaflet, :text
  end
end
