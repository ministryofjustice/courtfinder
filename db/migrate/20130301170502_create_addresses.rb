class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.string :postcode
      t.string :dx
      t.references :town
      t.references :address_type
      t.references :court

      t.timestamps
    end
    add_index :addresses, :town_id
    add_index :addresses, :address_type_id
    add_index :addresses, :court_id
  end
end
