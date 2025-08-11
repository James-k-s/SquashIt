class AddDescriptionToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :description, :string
  end
end
