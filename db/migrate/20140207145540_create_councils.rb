class CreateCouncils < ActiveRecord::Migration
  def change
    create_table :councils do |t|
      t.string :name

      t.timestamps
    end
    add_index :councils, :name
  end
end
