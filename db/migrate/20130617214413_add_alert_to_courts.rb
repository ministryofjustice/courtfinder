class AddAlertToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :alert, :string
  end
end
