class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show, :update_score]

  def show
    @match.ensure_rounds if @match.respond_to?(:ensure_rounds)

    @round_numbers    = (1..(@match.respond_to?(:max_sets) ? @match.max_sets : 5)).to_a
    @rounds_by_number = @match.rounds.order(:round_number).index_by(&:round_number)
    @max_rounds       = (defined?(Match::MAX_ROUNDS) ? Match::MAX_ROUNDS : @round_numbers.max)

    selected = params[:r].to_i
    selected = 1 unless @round_numbers.include?(selected)
    @current_round = @rounds_by_number[selected] || @match.rounds.create!(round_number: selected)
  end

  def update_score
    round_num = params[:r].to_i.nonzero? || 1
    round = @match.rounds.find_by(round_number: round_num) || @match.rounds.create!(round_number: round_num)

    if params[:win].present?
      winner_id = params[:win] == "p1" ? @match.player1_id : @match.player2_id
      round.update!(winner_id: winner_id)
    else
      p1_delta = params[:p1].to_i if params.key?(:p1)
      p2_delta = params[:p2].to_i if params.key?(:p2)

      Round.transaction do
        round.player1_score = [0, (round.player1_score || 0) + p1_delta].max if p1_delta
        round.player2_score = [0, (round.player2_score || 0) + p2_delta].max if p2_delta
        round.save!
      end

      # Auto-award: first to 11, win-by-2
      target = 11
      win_by = 2
      if round.winner_id.blank?
        s1 = round.player1_score || 0
        s2 = round.player2_score || 0
        if s1 >= target && (s1 - s2) >= win_by
          round.update!(winner_id: @match.player1_id)
        elsif s2 >= target && (s2 - s1) >= win_by
          round.update!(winner_id: @match.player2_id)
        end
      end
    end

    max_sets = (@match.respond_to?(:max_sets) ? @match.max_sets : 5)
    next_round_num =
      if round.winner_id.present? && round_num < max_sets
        round_num + 1
      else
        round_num
      end
    next_round = @match.rounds.find_or_create_by!(round_number: next_round_num)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "match_score",
          partial: "matches/match_score",
          locals: {
            match: @match,
            round: next_round,
            round_numbers: (1..max_sets).to_a,
            rounds_by_number: @match.rounds.order(:round_number).index_by(&:round_number)
          }
        )
      end
      format.html { redirect_to match_path(@match, r: next_round_num), notice: "Score updated." }
    end
  end

  private

  def set_match
    if params[:match_id].present?
      @tournament = Tournament.find(params[:id])
      @match = @tournament.matches.find(params[:match_id])
    else
      @match = Match.find(params[:id])
      @tournament = @match.tournament
    end
  end
end
