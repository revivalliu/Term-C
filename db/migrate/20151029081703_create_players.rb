class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id, null: false
      t.integer :server_id, null: false
      t.string :username
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.integer :size, null: false, default: 1
      t.integer :food_eaten, null: false, default: 0
      t.integer :players_eaten, null: false, default: 0
      t.integer :leaderboard_start_time, null: false, default: 0
      t.integer :leaderboard_end_time, null: false, default: 0
      t.integer :leaderboard_max_time, null: false, default: 0
      t.integer :top_leaderboard_position, null: false, default: 0
      t.integer :match_id
      t.string :player_type
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
