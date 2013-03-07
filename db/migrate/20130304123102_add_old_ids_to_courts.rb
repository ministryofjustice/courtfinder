class AddOldIdsToCourts < ActiveRecord::Migration
  def up
    add_column :courts, :old_postal_address_id, :integer
    add_column :courts, :old_court_address_id, :integer
    remove_column :courts, :area
    rename_column :addresses, :address1, :address_line_1
    rename_column :addresses, :address2, :address_line_2
    rename_column :addresses, :address3, :address_line_3
    rename_column :addresses, :address4, :address_line_4
    add_column :countries, :old_id, :integer
    add_column :counties, :old_id, :integer
    add_column :towns, :old_id, :integer
  end

  def down
    remove_column :courts, :old_postal_address_id
    remove_column :courts, :old_court_address_id
    add_column :courts, :area, :string
    rename_column :addresses, :address_line_1, :address1
    rename_column :addresses, :address_line_2, :address2
    rename_column :addresses, :address_line_3, :address3
    rename_column :addresses, :address_line_4, :address4
    remove_column :countries, :old_id
    remove_column :counties, :old_id
    remove_column :towns, :old_id
  end
end
