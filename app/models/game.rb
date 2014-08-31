class Game < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :users, through: :players
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  accepts_nested_attributes_for :teams

  before_save :mark_winner, unless: :has_winner?
  before_save :set_ratings, if: :rating_pending?
  after_save :invalidate_following, unless: :rating_pending?
  after_destroy :invalidate_following, unless: :rating_pending?

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

  def pretty_date
    created_at.in_time_zone('EST').strftime('%m/%d %I:%M %P')
  end

  def winning_team
    teams.find &:winner?
  end

  def losing_team
    teams.find { |t| !t.winner? }
  end

  def self.reset_ratings!
    update_all rating_pending: true
  end

  private
  def invalidate_following
    games = Game.where('created_at > ?', created_at).rating_set
    if games.any?
      games.reset_ratings!
      TrueskillHelper.rate_pending_games
    end
  end

  def set_ratings
    if Game.rating_pending.any?
      errors.add :base, 'Some games are still being rated. Try again later.'
      return false
    end

    TrueskillHelper.calculate_ratings self
  end

  def has_winner?
    teams.where(winner: true).count == 1
  end

  def mark_winner
    teams.max_by(&:goals).winner = true
  end

  def all_players_unique
    if users.uniq.length != users.length
      errors.add :base, 'All players must be unique'
    end
  end

  def goal_counts_unique
    if teams.first.goals == teams.second.goals
      errors.add :base, 'Game can not end in a tie'
    end
  end
end
