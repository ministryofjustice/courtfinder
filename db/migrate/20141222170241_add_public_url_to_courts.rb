class AddPublicUrlToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :public_url, :string, default: nil
  end
end
