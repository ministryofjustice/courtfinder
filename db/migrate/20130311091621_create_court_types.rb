class CreateCourtTypes < ActiveRecord::Migration
  def change
    create_table :court_types do |t|
      t.string :name
      t.string :old_description
      t.integer :old_id
      t.string :old_ids_split

      t.timestamps
    end
  end
end
