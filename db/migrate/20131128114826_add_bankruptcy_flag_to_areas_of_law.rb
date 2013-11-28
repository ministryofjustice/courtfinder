class AddBankruptcyFlagToAreasOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :type_bankruptcy, :boolean, :default => false
  end
end
