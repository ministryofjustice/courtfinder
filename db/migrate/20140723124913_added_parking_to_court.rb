class AddedParkingToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :parking_onsite, :string
    add_column :courts, :parking_offsite, :string
  end
end
