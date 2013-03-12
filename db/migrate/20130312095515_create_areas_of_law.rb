class CreateAreasOfLaw < ActiveRecord::Migration
  def change
    create_table :areas_of_law do |t|
      t.string :name
      t.integer :old_id

      t.timestamps
    end

    create_table :courts_areas_of_law do |t|
      t.references :court
      t.references :area_of_law

      t.timestamps
    end
    add_index :courts_areas_of_law, :court_id
    add_index :courts_areas_of_law, :area_of_law_id
  end
end
