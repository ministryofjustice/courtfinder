class RemoveAreaFromCourts < ActiveRecord::Migration
  def up
    # remove_column :courts, :area
  end

  def down
    # add_column :courts, :area, :string
  end
end
