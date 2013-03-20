class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.string :description
      t.references :court

      t.timestamps
    end
    add_index :emails, :court_id
  end
end
