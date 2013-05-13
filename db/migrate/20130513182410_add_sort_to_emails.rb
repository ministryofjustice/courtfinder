class AddSortToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :sort, :integer
  end
end
