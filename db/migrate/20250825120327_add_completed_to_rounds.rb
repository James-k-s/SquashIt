class AddCompletedToRounds < ActiveRecord::Migration[7.1]
  def change
    add_column :rounds, :completed, :boolean, default: false, null: false
  end
end
