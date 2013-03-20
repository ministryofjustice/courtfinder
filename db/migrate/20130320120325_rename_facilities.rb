class RenameFacilities < ActiveRecord::Migration
  def up
    rename_table :facilities, :court_facilities
    rename_column :court_facilities, :facility_type_id, :facility_id
    rename_table :facility_types, :facilities
  end

  def down
    rename_table :facilities, :facility_types
    rename_table :court_facilities, :facilities
    rename_column :facilities, :facility_id, :facility_type_id
  end
end
