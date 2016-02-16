
class GameConfiguration

  # Try to route pusher messages to user specific development environments
  def self.pusher_channel
    ENV['USER'].to_s + '_' + ENV['RAILS_ENV'].to_s
  end

  def players_per_server
    10
  end

  def food_per_server
    60
  end

  def food_size
    1
  end

  def food_spawn_rate
    1
  end

  def map_width
    2400
  end

  def map_height
    2400
  end

  def player_type
    'test'
  end

  def player_spawn_size
    1
  end

end