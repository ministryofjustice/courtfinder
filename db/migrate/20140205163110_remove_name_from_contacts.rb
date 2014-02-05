class RemoveNameFromContacts < ActiveRecord::Migration
  def up
    remove_column :contacts, :name
  end

  def down
    add_column :contacts, :name, :string
  end
end
