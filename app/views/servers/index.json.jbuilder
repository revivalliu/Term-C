json.array!(@servers) do |server|
  json.extract! server, :id, :id, :name, :region, :url, :startTime, :endTime
  json.url server_url(server, format: :json)
end
