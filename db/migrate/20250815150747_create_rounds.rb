class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :match, null: false, foreign_key: true
      t.integer :round_number
      t.integer :player1_score
      t.integer :player2_score
      t.integer :winner_id

      t.timestamps
    end
  end
end
