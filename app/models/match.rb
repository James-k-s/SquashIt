class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :player1, class_name: 'User', optional: true
  belongs_to :player2, class_name: 'User', optional: true
  belongs_to :winner, class_name: 'User', optional: true
  belongs_to :next_match, class_name: "Match", optional: true

  MAX_ROUNDS = 5

  def ensure_rounds
    (1..MAX_ROUNDS).each { |n| rounds.find_or_create_by!(round_number: n) }
  end

  def round(n)
    rounds.find_by(round_number: n)
  end


  has_many :rounds, dependent: :destroy
end
