class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :teams, through: :players
  has_many :games, through: :players

  validates_presence_of :name

  def rating
    0
  end

  def wins
    teams.winning.count
  end

  def losses
    games.count - wins
  end
end
