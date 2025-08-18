class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tournaments, foreign_key: :created_by_user_id, dependent: :destroy
  has_many :tournament_players, dependent: :destroy, foreign_key: :user_id
  has_many :tournaments_as_player, through: :tournament_players, source: :tournament

  has_many :matches_as_player1, class_name: 'Match', foreign_key: 'player1_id'
  has_many :matches_as_player2, class_name: 'Match', foreign_key: 'player2_id'
  has_many :matches_as_winner, class_name: 'Match', foreign_key: 'winner_id'

end
