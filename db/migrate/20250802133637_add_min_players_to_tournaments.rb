class AddMinPlayersToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :min_players, :integer
  end
end
