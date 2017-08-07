class CreateTableOfficialPostcodes < ActiveRecord::Migration
  def change
    create_table :official_postcodes do |t|
      t.string :postcode
      t.string :sector
      t.string :district
      t.string :area
    end
    add_index :official_postcodes, :postcode, unique: true
  end
end
