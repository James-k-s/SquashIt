class CreateInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :invites do |t|
      t.references :tournament, null: false, foreign_key: true
      t.string :email
      t.string :token
      t.string :status

      t.timestamps
    end
  end
end
