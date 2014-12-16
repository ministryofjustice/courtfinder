class AddGovUkFieldsToCourt < ActiveRecord::Migration


  def change
    add_column :courts, :uuid, :string
    add_column :courts, :gov_uk_md5, :string
    add_column :courts, :details_changed_at, :datetime, default: Time.at(0)
    add_column :courts, :gov_uk_updated_at, :datetime, default: Time.at(0)
    add_index :courts, :uuid, unique: true
  end
end
