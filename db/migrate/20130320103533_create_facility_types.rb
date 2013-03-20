class CreateFacilityTypes < ActiveRecord::Migration
  def change
    create_table :facility_types do |t|
      t.string :name
      t.string :image
      t.integer :old_id

      t.timestamps
    end
  end
end
