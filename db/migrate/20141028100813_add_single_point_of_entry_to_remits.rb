class AddSinglePointOfEntryToRemits < ActiveRecord::Migration
  def change
    change_table :remits do |t|
      t.boolean :single_point_of_entry, null: false, default: false
    end
  end
end
