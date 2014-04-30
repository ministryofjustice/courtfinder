class ChangeLocationInVersion < ActiveRecord::Migration
  def change
    rename_column :versions, :location, :network
  end
end
