class AddInvitedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_created_at, :datetime
    change_column :users, :invitation_token, :string, limit: 120
  end
end
