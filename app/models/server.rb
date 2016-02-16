class Server < ActiveRecord::Base
  has_many :players
  has_many :foods
  #has_many :traps
  #has_one  :leaderboard
end
