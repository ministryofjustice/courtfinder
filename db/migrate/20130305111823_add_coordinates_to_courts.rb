class AddCoordinatesToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :latitude, :decimal
    add_column :courts, :longitude, :decimal
  end
end
