class AddInvitedUserToInvites < ActiveRecord::Migration[7.1]
  def change
    add_reference :invites, :invited_user, foreign_key: { to_table: :users }

  end
end
