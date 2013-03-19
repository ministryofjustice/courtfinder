class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :telephone
      t.references :court
      t.references :contact_type
      t.boolean :in_leaflet
      t.integer :sort

      t.timestamps
    end
    add_index :contacts, :court_id
    add_index :contacts, :contact_type_id
  end
end
