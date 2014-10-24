class CreateJurisdictions < ActiveRecord::Migration
  def change
    create_table :jurisdictions do |t|
      t.belongs_to :remit, :council, null: false
      t.timestamps
    end

    add_index :jurisdictions, :remit_id
    add_index :jurisdictions, :council_id
  end
end
