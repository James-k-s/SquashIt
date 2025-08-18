class TournamentBracket
  def initialize(tournament)
    @tournament = tournament
    @players = tournament.tournament_players.includes(:user).map(&:user).shuffle
  end

  def generate_single_elimination
    return [] if @players.size < 2

    # Optional: clear old matches for a clean rebuild
    @tournament.matches.delete_all

    matches = []

    # Round 1: real player matches
    round_number = 1
    round_matches = []
    match_number = 1
    @players.each_slice(2) do |p1, p2|
      round_matches << Match.create!(
        tournament: @tournament,
        round_number: round_number,
        match_number: match_number,
        player1: p1,
        player2: p2,
        status: "pending"
      )
      match_number += 1
    end
    matches.concat(round_matches)

    # Next rounds: placeholders + linking
    while round_matches.size > 1
      round_number += 1
      next_round_size = (round_matches.size / 2.0).ceil
      next_round = Array.new(next_round_size) do
        m = Match.create!(
          tournament: @tournament,
          round_number: round_number,
          match_number: match_number,
          status: "TBD"
        )
        match_number += 1
        m
      end

      round_matches.each_with_index do |m, idx|
        target = next_round[idx / 2]
        m.update!(next_match_id: target.id, position_in_next_match: (idx % 2) + 1)
      end

      matches.concat(next_round)
      round_matches = next_round
    end

    matches
  end

  def advance_winner(match, winner)
    Match.transaction do
      match.update!(winner: winner)
      return unless match.next_match_id

      next_match = Match.find(match.next_match_id)
      if match.position_in_next_match == 1
        next_match.update!(player1: winner)
      else
        next_match.update!(player2: winner)
      end
    end
  end
end
