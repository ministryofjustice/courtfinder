class AddOldIdOpeningTypes < ActiveRecord::Migration
  def up
    add_column :opening_types, :old_id, :integer
  end

  def down
    remove_column :opening_types, :old_id
  end
end
