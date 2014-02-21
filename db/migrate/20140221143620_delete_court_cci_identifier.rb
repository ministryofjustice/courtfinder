class DeleteCourtCciIdentifier < ActiveRecord::Migration
  def up
    remove_column :courts, :cci_identifier
  end

  def down
    add_column :courts, :cci_identifier, :integer
  end
end
