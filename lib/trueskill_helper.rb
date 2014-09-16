require 'saulabs/trueskill'

include Saulabs::TrueSkill

class TrueskillHelper
  class << self
    @@default_skill_mean = 25.0
    @@default_skill_deviation = @@default_skill_mean / 3

    def user_rank(user)
      player_rank user.players.ordered.first
    end

    def player_rank(player)
      r = rating player
      ((r.mean - 3 * r.deviation) * 100).round
    end

    def rate_pending_games
      Game.transaction do
        Game.rating_pending.order(:created_at).each do |game|
          calculate_ratings game
          game.save
        end
      end
    end

    def calculate_ratings(game)
      teams = [:winning_team, :losing_team]
      ratings = teams.map do |sym|
        game.send(sym).players.map do |player|
          rating previous_player(player.user, game)
        end
      end

      # Score based alg or regular trueskill?
      # score_diff = game.teams.map(&:goals).reduce(&:-).abs
      FactorGraph.new(ratings, [1, 2]).update_skills

      teams.each_with_index do |sym, i|
        set_ratings game.send(sym).players, ratings[i]
      end

      game.rating_pending = false
      return true
    end

    def match_quality(*teams)
      mean_sum1, mean_sum2 = teams.map do |team|
        team.map(&:skill_mean).sum
      end

      std_dev_sum_squared = teams.map do |team|
        team.map { |p| p.skill_deviation ** 2 }.sum
      end.sum

      # Equation defined by TrueSkill. Tried my best
      # to make it readable
      # Beta squared times the number of players
      constant = teams.flatten.count * (@@default_skill_mean / 6) ** 2
      denominator = constant + std_dev_sum_squared
      sqrt_part = Math.sqrt(constant / denominator)
      exp_part = Math.exp((-1 * (mean_sum1 - mean_sum2) ** 2) / (2 * denominator))

      return exp_part * sqrt_part
    end

    def previous_player(user, model)
      user.players.ordered.where('created_at < ?', model_time(model)).first
    end

    private
    def model_time(model)
      model.created_at || Time.now
    end

    def set_ratings(players, ratings)
      # If you don't do the to_f here you get
      # arbitrary length decimals that are too long
      # for postgres
      players.each_with_index do |p, i|
        p.skill_mean = ratings[i].mean.to_f
        p.skill_deviation = ratings[i].deviation.to_f
      end
    end

    def rating(player)
      if player and player.skill_mean and player.skill_deviation
        Rating.new player.skill_mean, player.skill_deviation
      else
        Rating.new @@default_skill_mean, @@default_skill_deviation
      end
    end
  end
end
