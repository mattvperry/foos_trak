class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :team, inverse_of: :players
  has_one :game, through: :team

  validates_presence_of :user

  scope :ordered, -> { order(created_at: :desc) }

  enum position: [:offense, :defense]

  def rank
    TrueskillHelper.player_rank(self)
  end
end
