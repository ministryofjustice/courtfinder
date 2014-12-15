class AddGovUkFieldsToCourt < ActiveRecord::Migration

  @@md5 = Digest::MD5.new.update('Not yet pushed to gov.uk').hexdigest

  def change
    add_column :courts, :uuid, :string, null: false
    add_column :courts, :last_push_md4, :string, default: @@md5
  end
  
end
