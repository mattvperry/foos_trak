json.array!(@games) do |game|
  json.extract! game, :id, :rating_pending
  json.url game_url(game, format: :json)
end
