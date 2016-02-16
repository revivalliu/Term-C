class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      #t.integer :id
      t.integer :session_id, null: false
      t.integer :food_eaten, null: false, default: 0
      t.integer :players_eaten, null: false, default: 0
      t.integer :traps_eaten, null: false, default: 0
      t.integer :highest_mass, null: false, default: 0
      t.integer :leaderboard_time, null: false, default: 0
      t.integer :top_position, null: false, default: 0
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
