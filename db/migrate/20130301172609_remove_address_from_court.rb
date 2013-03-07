class RemoveAddressFromCourt < ActiveRecord::Migration
  def up
    remove_column :courts, :old_postal_address_id
    remove_column :courts, :old_court_address_id
    remove_column :courts, :address_id
    remove_column :courts, :old_address_postal_flag
    remove_column :courts, :address_line_1
    remove_column :courts, :address_line_2
    remove_column :courts, :address_line_3
    remove_column :courts, :address_line_4
    remove_column :courts, :postcode
    remove_column :courts, :dx_number
    remove_column :courts, :court_town_id
    remove_column :courts, :court_latitude
    remove_column :courts, :court_longitude
  end
end
