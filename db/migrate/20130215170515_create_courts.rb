class CreateCourts < ActiveRecord::Migration
  def change
    create_table :courts do |t|
      t.string :name
      t.integer :court_number
      t.text :info

      t.timestamps
    end
  end
end
