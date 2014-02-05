class RemoveDescriptionFromEmail < ActiveRecord::Migration
  def up
    remove_column :emails, :description
  end

  def down
    add_column :emails, :description, :string
  end
end
