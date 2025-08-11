class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tournaments, foreign_key: :created_by_user_id, dependent: :destroy
  has_many :tournament_players, dependent: :destroy, foreign_key: :user_id
  has_many :tournaments_as_player, through: :tournament_players, source: :tournament

end
