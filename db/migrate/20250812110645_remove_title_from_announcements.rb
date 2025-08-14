class RemoveTitleFromAnnouncements < ActiveRecord::Migration[7.1]
  def change
    remove_column :announcements, :title, :string
  end
end
