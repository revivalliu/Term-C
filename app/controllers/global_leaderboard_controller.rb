class GlobalLeaderboardController < ApplicationController
  layout false
  def index
    @leaderboard = GlobalLeaderboard.new
    @largest_cell = @leaderboard.largest_cell
    @longest_living_cell = @leaderboard.longest_living_cell
    @most_food_eaten = @leaderboard.most_food_eaten
    @most_players_eaten = @leaderboard.most_players_eaten
    @leaderboard_time = @leaderboard.longest_leaderboard_time
    @highest_time_in_game = @leaderboard.highest_time_in_game
  end
end
