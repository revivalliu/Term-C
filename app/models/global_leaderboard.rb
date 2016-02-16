class GlobalLeaderboard
  def initialize(options = {})
    @options = options
    @sessions = Session.all
  end

  def most_food_eaten
    list = []
    Match.order(:food_eaten => 'DESC').limit(list_size).each do |match|
      list.push({
          :username => match.session.user.email,
          :food_eaten => match.food_eaten
      })
    end
  end

  def most_players_eaten
    list = []
    Match.order(:players_eaten => 'DESC').limit(list_size).each do |match|
      list.push({
                    :username => match.session.user.email,
                    :players_eaten => match.players_eaten
                })
    end
  end

  def largest_cell
    list = []
    Match.order(:highest_mass => 'DESC').limit(list_size).each do |match|
      list.push({
          :username => match.session.user.email,
          :highest_mass => match.highest_mass
      })
    end
  end

  def longest_leaderboard_time
    list = []
    Match.order(:leaderboard_time => 'DESC').limit(list_size).each do |match|
      list.push({
          :username => match.session.user.email,
          :leaderboard_time => match.leaderboard_time
      })
    end
  end

  def longest_living_cell
    list = []
    Match.select(" *, (end_time - created_at) as diff ").where(' end_time IS NOT NULL ').order(" diff DESC").limit(list_size).each do |match|
      list.push({
          :username => match.session.user.email,
          :match_time => match.diff
      })
    end
  end

  def highest_time_in_game
    list = []
    Session.select(" *, (end_time - created_at) as diff ").where(' end_time IS NOT NULL ').order(" diff DESC").limit(list_size).each do |session|
      list.push({
          :username => session.user.email,
          :session_time => session.diff
      })
    end
  end

  def list_size
    @options[:list_size] ? @options[:list_size] : 5
  end

end