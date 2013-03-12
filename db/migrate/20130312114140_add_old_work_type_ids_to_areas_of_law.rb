class AddOldWorkTypeIdsToAreasOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :old_ids_split, :string
    add_column :areas_of_law, :action, :string
    add_column :areas_of_law, :sort, :integer
  end
end
