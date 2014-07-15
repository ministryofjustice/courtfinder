class AddDirectionsToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :directions, :text
  end
end
