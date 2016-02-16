class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      #t.integer :id
      t.string :name
      t.integer :region
      t.string :url
      t.integer :player_count, null: false, default: 0
      t.timestamps null: false
    end
  end
end
