class AddExplanationToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :explanation, :string, null: true, :limit => 85
  end
end
