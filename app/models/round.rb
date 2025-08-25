class Round < ApplicationRecord
  belongs_to :match
  belongs_to :winner, class_name: 'User', optional: true

  def finished?
    winner_id.present?
  end

  validate :winner_is_a_match_player, if: -> { winner_id.present? }

  private

  def winner_is_a_match_player
    return if [match.player1_id, match.player2_id].include?(winner_id)
    errors.add(:winner_id, "must be one of the match players")
  end

end
