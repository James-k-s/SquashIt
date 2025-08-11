class ChangeDefaultStatusOnTournaments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tournaments, :status, "scheduled"
  end
end
