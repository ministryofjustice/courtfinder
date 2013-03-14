class AddSlugToAreasOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :slug, :string
  end
end
