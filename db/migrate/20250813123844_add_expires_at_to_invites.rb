class AddExpiresAtToInvites < ActiveRecord::Migration[7.1]
  def change
    add_column :invites, :expires_at, :datetime
  end
end
