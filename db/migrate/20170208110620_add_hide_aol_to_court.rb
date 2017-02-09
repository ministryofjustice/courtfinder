class AddHideAolToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :hide_aols, :boolean, default: false
  end
end
