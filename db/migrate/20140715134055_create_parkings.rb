class CreateParkings < ActiveRecord::Migration
  def change
    create_table :parkings do |t|
      t.string :parking_type
      t.boolean :paid
      t.integer :court_id
      
      t.timestamps
    end

    add_index :parkings, :court_id
  end
end
