class AddDetailsToAreaOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :external_link, :string, :limit => 2048, :null => true
    add_column :areas_of_law, :external_link_desc, :string, :limit => 255, :null => true
  end
end
