class RenameCourtsAreasOfLawToRemits < ActiveRecord::Migration
  def change
    change_table :courts_areas_of_law do |t|
      t.remove_index :court_id
      t.remove_index :area_of_law_id
    end

    rename_table :courts_areas_of_law, :remits

    change_table :remits do |t|
      t.index :court_id
      t.index :area_of_law_id
    end
  end
end
