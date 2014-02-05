class AddContactTypeToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :contact_type_id, :integer
  end
end
