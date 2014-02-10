class AddTypeChidrenToAreaOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :type_children, :boolean, :default => false
  end
end
