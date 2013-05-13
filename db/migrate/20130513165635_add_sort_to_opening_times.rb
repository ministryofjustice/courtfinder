class AddSortToOpeningTimes < ActiveRecord::Migration
  def change
    add_column :opening_times, :sort, :integer
  end
end
