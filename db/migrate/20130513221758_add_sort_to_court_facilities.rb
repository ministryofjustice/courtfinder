class AddSortToCourtFacilities < ActiveRecord::Migration
  def change
    add_column :court_facilities, :sort, :integer
  end
end
