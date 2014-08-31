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

      FactorGraph.new(ratings, [1, 2]).update_skills

      teams.each_with_index do |sym, i|
        set_ratings game.send(sym).players, ratings[i]
      end

      game.rating_pending = false
      return true
    end

    def previous_player(user, model)
      user.players.ordered.where('created_at < ?', model_time(model)).first
    end

    private
    def model_time(model)
      model.created_at || Time.now
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
        Rating.new @@default_skill_mean, @@default_skill_deviation
      end
    end
  end
end
