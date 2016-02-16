def send_message
  message = {:message => '{"message":{"playerId":1,"position":{"x":1508.607689049669,"y":1237.156174138858,"type":25},"collisions":[]}}'}
  m = Message.new message
  gs = GameServer.new m
end
