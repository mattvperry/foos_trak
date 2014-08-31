require 'saulabs/trueskill'

class TrueskillHelper
  class << self
    include Saulabs::TrueSkill

    @default_skill_mean = 25.0
    @default_skill_deviation = @default_skill_mean / 3

    DEFAULT_RATING = Rating.new(@default_skill_mean, @default_skill_deviation)

    def user_rank(user)
      player_rank(user.players.ordered.first)
    end

    def player_rank(player)
      r = rating(player)
      ((r.mean - 3 * r.deviation) * 100).floor
    end

    def rate_pending_games
      Game.transaction do
        Game.rating_pending.order(:created_at).each do |game|
          calculate_ratings(game)
          game.save!
        end
      end
    end

    def calculate_ratings(game)
      get_prev_rating = Proc.new do |player|
        rating(previous_player(player.user, game))
      end

      ratings = [
        game.winning_team.players.map(&get_prev_rating),
        game.losing_team.players.map(&get_prev_rating)
      ]

      FactorGraph.new(ratings, [1, 2]).update_skills

      set_ratings(game.winning_team.players, ratings[0])
      set_ratings(game.losing_team.players, ratings[1])

      game.rating_pending = false
      return true
    end

    def previous_player(user, game)
      user.players.ordered.where('created_at < ?', game_time(game)).first
    end

    private
    def game_time(game)
      game.created_at || Time.now
    end

    def set_ratings(players, ratings)
      players.each_with_index do |p, i|
        p.skill_mean = ratings[i].mean
        p.skill_deviation = ratings[i].deviation
      end
    end

    def rating(player)
      if player and player.skill_mean and player.skill_deviation
        Rating.new player.skill_mean, player.skill_deviation
      else
        DEFAULT_RATING
      end
    end
  end
end
