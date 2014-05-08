class CreateAreaOfLawGroups < ActiveRecord::Migration
  def change
    create_table :area_of_law_groups do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
