class Player < ActiveRecord::Base
  has_many :games_players
  has_many :games, through: :games_players
  validates :initials, uniqueness: true
  validates :initials, presence: true
  before_save :upcase_initials

  protected

  def upcase_initials
    self.initials = self.initials.upcase
  end
end
