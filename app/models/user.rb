class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :teams, through: :players
  has_many :games, through: :players
  has_many :created_games, class_name: 'Game', foreign_key: :creator_id

  validates_presence_of :name

  def self.ranked
    all.sort_by(&:rank).reverse
  end

  def rank
    TrueskillHelper.user_rank(self)
  end

  def skill_mean
    (most_recent_player.try(:skill_mean) || 0).round(2)
  end

  def skill_deviation
    (most_recent_player.try(:skill_deviation) || 0).round(2)
  end

  def standing
    User.select(:id).ranked.find_index(self).succ
  end

  def alias
    email.split('@').first
  end

  def participated_in?(game)
    games.where(id: game).any?
  end

  def created_game?(game)
    created_games.where(id: game).any?
  end

  def wins
    games.merge(teams.winning)
  end

  def losses
    games.merge(teams.losing)
  end

  def win_count
    teams.winning.count
  end

  def loss_count
    teams.losing.count
  end

  private
  def most_recent_player
    players.ordered.first
  end
end
