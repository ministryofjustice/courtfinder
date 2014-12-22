class SetUuidNotNull < ActiveRecord::Migration
  def up
    change_column :courts, :uuid, :string, :null => false
  end

  def down
    change_column :courts, :uuid, :string, :null => true
  end
end
