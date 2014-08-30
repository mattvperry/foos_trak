class Game < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :users, through: :players

  accepts_nested_attributes_for :teams

  before_save :mark_winner, unless: :has_winner?

  validates_size_of :teams, is: 2
  validate :all_players_unique
  validate :goal_counts_unique

  def build_doubles
    2.times { teams.build }
    teams.each do |t|
      t.players.build position: :offense
      t.players.build position: :defense
    end
  end

  private
  def has_winner?
    teams.where(winner: true).count == 1
  end

  def mark_winner
    teams.select('teams.*', 'MAX(teams.goals)').first.update(winner: true)
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
