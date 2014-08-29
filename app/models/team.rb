class Team < ActiveRecord::Base
  belongs_to :game

  has_many :players, dependent: :destroy
  has_many :users, through: :players

  accepts_nested_attributes_for :players

  validates_numericality_of :goals,
    only_integer: true, greater_than_or_equal_to: 0
end
