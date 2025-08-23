class MatchesController < ApplicationController
before_action :authenticate_user!

  def show
    @tournament = Tournament.find(params[:id])
    @match = @tournament.matches.find(params[:match_id])

    @round_numbers = (1..Match::MAX_ROUNDS).to_a
    selected = params[:r].to_i
    selected = 1 unless @round_numbers.include?(selected)
    @current_round = @match.round(selected)
  end

end
