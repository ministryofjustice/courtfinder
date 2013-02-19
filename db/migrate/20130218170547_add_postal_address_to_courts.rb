class AddPostalAddressToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :address_id, :integer
    add_column :courts, :old_address_postal_flag, :integer
    add_column :courts, :address_line_1, :string
    add_column :courts, :address_line_2, :string
    add_column :courts, :address_line_3, :string
    add_column :courts, :address_line_4, :string
    add_column :courts, :postcode, :string
    add_column :courts, :dx_number, :string
    add_column :courts, :court_town_id, :integer
    add_column :courts, :court_latitude, :string
    add_column :courts, :court_longitude, :string
  end
end
