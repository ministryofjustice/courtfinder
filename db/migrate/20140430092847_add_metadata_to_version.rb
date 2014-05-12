class AddMetadataToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :ip, :string
    add_column :versions, :location, :string
  end
end
