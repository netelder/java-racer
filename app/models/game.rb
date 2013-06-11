class Game < ActiveRecord::Base
  has_many :games_players
  has_many :players, through: :games_players
  # validates :game_has_two_players

  # protected

  # def game_has_two_players

  # end
end
