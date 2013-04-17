class RemoveLimitOnCourtFacilitiesDescription < ActiveRecord::Migration
  def up
    change_column :court_facilities, :description, :text, :limit => nil
  end

  def down
  end
end
