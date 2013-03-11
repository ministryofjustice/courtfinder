class CreateCourtTypesCourts < ActiveRecord::Migration
  def change
    create_table :court_types_courts do |t|
      t.references :court
      t.references :court_type

      t.timestamps
    end
    add_index :court_types_courts, :court_id
    add_index :court_types_courts, :court_type_id
  end
end
