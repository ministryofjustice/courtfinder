class DropCourtCouncilLinks < ActiveRecord::Migration
  def change
    drop_table :court_council_links
  end
end
