class CreateAreaOfLawGroups < ActiveRecord::Migration
  def change
    create_table :area_of_law_groups do |t|
      t.string :name

      t.timestamps
    end

    add_column :areas_of_law, :group_id, :integer, references: :area_of_law_groups
  end
end
