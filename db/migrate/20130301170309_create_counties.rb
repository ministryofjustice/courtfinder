class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.references :country

      t.timestamps
    end
    add_index :counties, :country_id
  end
end
