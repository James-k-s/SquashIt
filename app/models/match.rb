class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :player1, class_name: 'User', optional: true
  belongs_to :player2, class_name: 'User', optional: true
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :next_match, class_name: "Match", optional: true


  has_many :rounds, dependent: :destroy
end
