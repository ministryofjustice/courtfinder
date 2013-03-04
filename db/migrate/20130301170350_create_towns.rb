class CreateTowns < ActiveRecord::Migration
  def change
    create_table :towns do |t|
      t.string :name
      t.references :county

      t.timestamps
    end
    add_index :towns, :county_id
  end
end
