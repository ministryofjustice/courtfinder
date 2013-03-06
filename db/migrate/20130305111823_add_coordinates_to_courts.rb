class AddCoordinatesToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :latitude, :decimal
    add_column :courts, :longitude, :decimal
	
	remove_column :courts, :court_longitude
  end
end
