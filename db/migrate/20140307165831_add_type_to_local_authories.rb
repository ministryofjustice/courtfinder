class AddTypeToLocalAuthories < ActiveRecord::Migration
  def change
    add_column :local_authorities, :type, :string
  end
end
