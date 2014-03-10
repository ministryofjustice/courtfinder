class RenameTypeToAreaOfLawId < ActiveRecord::Migration
  def change
    remove_column :court_council_links, :type
    add_column :court_council_links, :area_of_law_id, :integer
  end
end
