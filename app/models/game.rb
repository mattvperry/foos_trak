class Game < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :users, through: :players

  accepts_nested_attributes_for :teams

  before_save :mark_winner, unless: :has_winner?
  before_save :set_ratings, if: :rating_pending?
  after_save :invalidate_following
  after_destroy :invalidate_following

  validates_size_of :teams, is: 2
  validate :all_players_unique
  validate :goal_counts_unique

  scope :rating_pending, -> { where(rating_pending: true) }
  scope :rating_set, -> { where(rating_pending: false) }

  paginates_per 20

  def build_doubles
    2.times { teams.build }
    teams.each do |t|
      t.players.build position: :offense
      t.players.build position: :defense
    end
  end

  def winning_team
    teams.find(&:winner?)
  end

  def losing_team
    teams.find { |t| !t.winner? }
  end

  def self.reset_ratings!
    update_all(rating_pending: true)
    TrueskillHelper.rate_pending_games
  end

  private
  def invalidate_following
    Game.where('created_at > ?', created_at).rating_set.reset_ratings!
  end

  def set_ratings
    if Game.rating_pending.any?
      errors.add(:base, 'Some games are still being rated. Try again later.')
      return false
    end

    TrueskillHelper.calculate_ratings(self)
  end

  def has_winner?
    teams.where(winner: true).count == 1
  end

  def mark_winner
    teams.max_by(&:goals).winner = true
  end

  def all_players_unique
    if users.uniq.length != users.length
      errors.add(:base, 'All players must be unique')
    end
  end

  def goal_counts_unique
    if teams.first.goals == teams.second.goals
      errors.add(:base, 'Game can not end in a tie')
    end
  end
end
