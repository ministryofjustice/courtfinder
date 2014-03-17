class AddFamilyTypesToAreasOfLaw < ActiveRecord::Migration
  def change
  	add_column :areas_of_law, :type_divorce, :boolean, default: false
  	add_column :areas_of_law, :type_adoption, :boolean, default: false
  end
end
