class AddAreaToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :area, :string
  end
end
