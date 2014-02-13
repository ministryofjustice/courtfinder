class CreateLocalAuthority < ActiveRecord::Migration
  def change
    create_table :local_authorities do |t|
      t.references :court
      t.references :council
      t.timestamps
    end
  end
end
