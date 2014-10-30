class AddParkingBlueBadgeToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :parking_blue_badge, :string
  end
end
