class RenameCouncilsToLocalAuthorities < ActiveRecord::Migration
  def change
    remove_index :councils, :name
    rename_table :councils, :local_authorities
    add_index :local_authorities, :name

    remove_index :jurisdictions, :council_id
    change_table :jurisdictions do |t|
      t.rename :council_id, :local_authority_id
    end
    add_index :jurisdictions, :local_authority_id
  end
end
