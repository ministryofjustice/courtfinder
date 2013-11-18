class CreatePostcodeCourts < ActiveRecord::Migration
  def change
    create_table :postcode_courts do |t|
      t.string :postcode
      t.integer :court_number
      t.string :court_name
      t.references :court

      t.timestamps
    end
    add_index :postcode_courts, :court_number
  end
end
