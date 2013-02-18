class AddMoreInfoCourts < ActiveRecord::Migration
  def change
	add_column :courts, :area_id, :integer
	add_column :courts, :cci_identifier, :integer
	add_column :courts, :cci_code, :integer
	add_column :courts, :old_id, :integer
	add_column :courts, :old_postal_address_id, :integer
	add_column :courts, :old_court_address_id, :integer
	add_column :courts, :old_court_type_id, :integer
  end
end
