class AddMaxPlayersToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :max_players, :integer
  end
end
