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

  def rank
    TrueskillHelper.user_rank(self)
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
end
