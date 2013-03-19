class CreateContactTypes < ActiveRecord::Migration
  def change
    create_table :contact_types do |t|
      t.string :name
      t.integer :old_id

      t.timestamps
    end
  end
end
