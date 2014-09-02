module GamesHelper
  def can_modify_game(game)
    current_user.participated_in?(game) or current_user.created_game?(game)
  end
end
