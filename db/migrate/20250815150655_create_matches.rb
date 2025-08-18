class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :tournament, null: false, foreign_key: true
      t.integer :player1_id
      t.integer :player2_id
      t.integer :winner_id
      t.integer :match_number

      t.timestamps
    end
  end
end
