class Announcement < ApplicationRecord
  belongs_to :tournament
  belongs_to :user
  validates  :body, presence: true
end
