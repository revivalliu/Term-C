json.array!(@sessions) do |session|
  json.extract! session, :id, :id, :name, :userId, :serverId, :startTime, :endTime
  json.url session_url(session, format: :json)
end
