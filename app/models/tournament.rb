class Tournament < ApplicationRecord
  belongs_to :created_by_user, class_name: "User"
  has_many :tournament_players
  has_many :players, through: :tournament_players, source: :user


  validates :name, presence: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :bracket_type, presence: true
  validates :max_players, numericality: { only_integer: true, greater_than: 0 }
end
