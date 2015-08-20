class AddGssCodeToLocalAuthorities < ActiveRecord::Migration
  def change
    add_column :local_authorities, :gss_code, :string, max_length: 10, null: true, unique: true
    add_index :local_authorities, [:gss_code], name: 'ix_la_gss_code'
  end
end
