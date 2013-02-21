class AddSlugToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :slug, :string
	add_index :courts, :slug
  end
end
