class AddStatusAndBestOfToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :status, :string
    add_column :matches, :best_of, :integer
  end
end
