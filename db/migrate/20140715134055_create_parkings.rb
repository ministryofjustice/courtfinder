class CreateParkings < ActiveRecord::Migration
  def change
    create_table :parkings do |t|
      t.string :location_and_cost
      t.timestamps
    end
    add_index :parkings, :location_and_cost

    create_table :courts_parkings, id: false do |t|
      t.belongs_to :court
      t.belongs_to :parking
    end
  end
end
