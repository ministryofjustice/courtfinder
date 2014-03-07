class AddAreaOfLawToLocalAuthories < ActiveRecord::Migration
  def change
    add_column :local_authorities, :area_of_law, :string
  end
end
