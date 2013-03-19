class CreateOpeningTimes < ActiveRecord::Migration
  def change
    create_table :opening_times do |t|
      t.string :name
      t.references :court
      t.references :opening_type

      t.timestamps
    end
    add_index :opening_times, :court_id
    add_index :opening_times, :opening_type_id
  end
end
