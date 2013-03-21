class AddDisplayToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :display, :boolean
  end
end
