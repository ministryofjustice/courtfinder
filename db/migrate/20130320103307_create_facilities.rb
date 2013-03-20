class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :description
      t.references :court
      t.references :facility_type

      t.timestamps
    end
    add_index :facilities, :court_id
    add_index :facilities, :facility_type_id
  end
end
