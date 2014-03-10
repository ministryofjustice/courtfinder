class RenameLocalAuthorities < ActiveRecord::Migration
	 def up
		rename_table :local_authorities, :councils_courts
		remove_column :councils_courts, :id
		remove_column :councils_courts, :created_at
		remove_column :councils_courts, :updated_at

		add_index :councils_courts, [:court_id, :council_id]
  end

  def down
		rename_table :councils_courts, :local_authorities
		add_column :local_authorities, :id, :integer
		add_column :local_authorities, :created_at, :datetime
		add_column :local_authorities, :updated_at, :datetime
  end

end
