class AddPrimaryToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :is_primary, :boolean
  end
end
