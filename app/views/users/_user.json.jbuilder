json.extract! user, :id, :name, :email, :standing, :rank,
  :win_count, :loss_count, :created_at

json.players user.players.ordered.reverse do |player|
  json.rank player.rank
  json.position player.position
  json.skill_mean player.skill_mean.to_f
  json.skill_deviation player.skill_deviation.to_f
  json.created_at player.created_at
end
