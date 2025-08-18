class AddNextMatchAndPositionToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :next_match_id, :integer
    add_column :matches, :position_in_next_match, :integer
  end
end
