class CreateTournaments < ActiveRecord::Migration[7.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.string :bracket_type
      t.references :created_by_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
