class CreateTournamentPlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :tournament_players do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
