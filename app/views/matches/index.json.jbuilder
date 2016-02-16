json.array!(@matches) do |match|
  json.extract! match, :id, :id, :sessionId, :foodEaten, :playersEaten, :trapsEaten, :highestMass, :leaderboardTime, :topPosition
  json.url match_url(match, format: :json)
end
