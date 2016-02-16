class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.integer :server_id, null: false
      t.integer :size, null: false, default: 0
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.string :asset

      t.timestamps null: false
    end
  end
end
