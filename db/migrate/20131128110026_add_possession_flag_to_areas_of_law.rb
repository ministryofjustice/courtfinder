class AddPossessionFlagToAreasOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :type_possession, :boolean, :default => false
  end
end
