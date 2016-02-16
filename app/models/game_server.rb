require 'pusher'
require 'hashie'
require 'json'
include SessionsHelper

# Pusher.app_id = '146683'
# Pusher.key = 'e415bc2547e9d73f06a2'
# Pusher.secret = '19af28a37ee2ebf241ac'

Pusher.app_id = '158458'
Pusher.key = '758478f53f799323df26'
Pusher.secret = '28f523d825230cb3f231'

class GameServer

  def initialize(message, options = {})
    @M = message
    @config = GameConfiguration.new
    @options = options
    @channel = GameConfiguration.pusher_channel
    @event = 'my_event'
    initialize_game_objects message
    process_client_message
  end

  def initialize_game_objects(message)
    @message = parse_message message
    @server = server # Must be before Player, as Player server_id cannot be null
    @player = player # create and return or return player obj
    @user = user
    @M.user_id = @user.id
    @M.save
    @session = session
    @match = match
  end

  def end_game
    end_session
    end_match
    @player.delete
  end

  def user
    @user ||= user_record
  end

  def user_record
    user = User.where(:id => @player.user_id)
    if user.nil?
      raise "User ID required but not found"
    else
      user.first
    end
  end

  def session
    @session ||= session_record
  end

  def session_record
    session = Session.where(:user_id => @user.id, :server_id => @server.id)
    if session.size == 0 || !session.last.end_time.nil?
      spawn_session
    else
      session.last
    end
  end

  def spawn_session
    session = Session.new(:user_id => @user.id, :server_id => @server.id)
    session.save
    session
  end

  def end_session
    @session.end_time = last_message_received.created_at
    @session.save
  end

  def last_message_received
    @last_message ||= Message.where(:user_id => @user.id).last
  end

  def match
    @match ||= match_record
  end

  def match_record
    match = Match.where(:session_id => @session.id)
    if match.size == 0 || !match.last.end_time.nil?
      spawn_match
    else
      match.last
    end
  end

  def spawn_match
    match = Match.new(:session_id => @session.id)
    match.save
    match
  end

  def end_match
    puts "\nSession: " + @session.inspect
    puts "\nSession.match: " + @session.matches.inspect
    match = @session.matches.last
    puts "\n\nEND MATCH"
    puts "\n" + match.inspect
    match.food_eaten = @player.food_eaten
    @player.food_eaten = 0
    match.players_eaten = @player.players_eaten
    @player.players_eaten = 0
    match.highest_mass = @player.size
    @player.size = @config.player_spawn_size
    match.leaderboard_time = (@player.leaderboard_start_time.nil? ? 0 : @player.leaderboard_start_time) - (@player.leaderboard_end_time.nil? ? 0 : @player.leaderboard_end_time)
    @player.leaderboard_start_time = 0
    @player.leaderboard_end_time = 0
    match.top_position = @player.top_leaderboard_position.nil? ? 0 : @player.top_leaderboard_position
    @player.top_leaderboard_position = 0
    match.end_time = last_message_received.created_at
    puts "\n" + match.inspect
    match.save
    player.save
    puts "\nMATCH SAVED"
    match
  end

  def parse_message(message)
    # puts "\n\nGAME SERVER\n"
    # puts message.inspect
    # puts "\n\n"

    json = JSON.parse(message.message)
    # puts "\nJSON\n"
    # puts json.inspect
    # puts "\n\n"
    @message = Hashie::Mash.new(json['message'])
  end

  def process_client_message
    begin
      if check_end_game
        end_game
        return
      end
      process_collisions
      update_game_state
      publish_game_state
    rescue => e
      puts "\n-----Error-----\n"
      puts e.inspect
      puts e.message
      puts e.backtrace
      puts "\n"
    end
  end

  def check_end_game
    !@message.endGame.nil?
  end

  def update_game_state
    Player.update(@player.id, {:x => @message.position.x, :y => @message.position.y})
    spawn_food
    @message['player'] = @player.as_json
    @message['foods'] = Food.select(" id, size, x, y ").as_json
    #@message['server'] = @server.as_json
    @message['username'] = @player.user.name
  end

  def publish_game_state
    #tmp = "#{message.playerId} moved to x: #{message.position.x} y: #{message.position.y}"
    #puts "\nPusher Channel: #{@channel}\nPusher Event: #{@event}\n"
    Pusher.trigger(@channel, @event, {:message => JSON.generate(@message)})
  end

  def process_collisions
    @message['remove_foods'] = []
    @message['remove_players'] = []
    @message['end_match'] = []
    @message.collisions.each { |c|
      if c[0].type == 'player' && c[1].type == 'food'
        player_food_collision c
      end

      if c[0].type == 'player' && c[1].type == 'player'
        player_player_collision c
      end
    }
  end

  def player_food_collision(collision)
    #puts "\n\n\nPLAYER - FOOD collision\n\n\n";
    begin
      food = Food.find(collision[1].object.id)
      puts "\n\nPLAYER - FOOD Collision message: " + collision.inspect
      puts "\nCollision by player: " + @player.inspect
      puts "\nCollision with food: " + food.inspect
      puts "\n\n"


      player_size = @player.size + food.size
      food_eaten = @player.food_eaten + 1
      updates = {:size => player_size, :food_eaten => food_eaten}
      Player.update @player.id, updates

      food.destroy

      @message['remove_foods'].push food.id
    rescue
    end
  end

  def player_player_collision(collision)
    puts "\n\n\nPLAYER - PLAYER collision\n\n\n";
    begin
      otherPlayer = Player.where(:user_id => collision[1].object.id)
      if otherPlayer.size > 0
        otherPlayer = otherPlayer.first
        puts "\n\nPLAYER - PLAYER Collision message: " + collision.inspect
        puts "\nCollision by player: " + @player.inspect
        puts "\nCollision with player: " + otherPlayer.inspect
        puts "\n#{@player.size} <=>? #{otherPlayer.size}"
        puts "\n\n"

        if otherPlayer.size < @player.size
          puts "OTHERPLAYER < PLAYER"
          player_size = @player.size + otherPlayer.size
          players_eaten = @player.players_eaten + 1
          Player.update(@player.id, {:size => player_size, :players_eaten => players_eaten})
          @message['end_match'].push(end_of_match_message(collision[1].object.id))
        elsif @player.size < otherPlayer.size
          puts "\n\n\n\n\n\n\nPLAYER < OTHERPLAYER - END PLAYER MATCH\n\n\n\n\n\n"
          match = end_match
          @message['end_match'].push(end_of_match_message(@player.user_id, match.to_json))
        end
      end
    end
  end

  def end_of_match_message(id, data = nil)
    if data.nil?
      {:id => id}
    else
      {:id => id, :data => data}
    end
  end

  def spawn_food
    # puts "\n\nFOOD FOOD FOOD\n" + @server.foods.inspect + "\n\n"
    last = @server.foods.last
    if last.nil?
      new_food
    else
      last_created_at = last.nil? ? Time.now.getutc.to_i : last.created_at.to_i
      time = Time.now.getutc.to_i
      diff = time - last_created_at

      # puts "\n"
      # puts "\nfoods.size() " + @server.foods.size.inspect
      # puts "\ndiff " + diff.inspect
      # puts "\n"

      if @server.foods.size < @config.food_per_server and diff > @config.food_spawn_rate
        new_food
      end
    end
  end


  def player
    @player ||= player_record
  end

  def player_record
    player = Player.where(:user_id => @message.playerId)

    # if end_time is null, game is current
    # else create a new player record

    if player.size == 0
      spawn_player
    else
      player.first
    end
  end

  def spawn_player
    player = Player.new new_player_params
    player.save
    player
  end

  def new_player_params
    {
        :user_id => @message.playerId,
        :server_id => @server.nil? ? @server : @server.id,
        :username => '',
        :x => @message.position.x,
        :y => @message.position.y,
        :size => @config.player_spawn_size,
        :player_type => @config.player_type,
    }
  end


  def server
    @server ||= server_record
  end

  def server_record
    if @player.nil?
      servers = Server.where(" player_count < #{@config.players_per_server} ")
      if servers.size == 0
        server = spawn_server
      else
        server = servers.first
      end
    else
      Server.find @player.server_id
    end
  end

  def spawn_server
    server = Server.new(new_server_params)
    server.save
    server
  end

  def new_server_params
    {
        :name => '',
        :region => '',
        :url => '',
        :player_count => 0
    }
  end


  def new_food
    food = Food.new(new_food_params(@server))
    food.save
    food
  end

  def new_food_params(server)
    {
        :server_id => server.id,
        :size => @config.food_size,
        :x => random(@config.map_width),
        :y => random(@config.map_height),
        :asset => '' # TODO: Color or asset assignment
    }
  end


  def random(range)
    r = Random.new
    r.rand(range)
  end

end