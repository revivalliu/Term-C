class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      #t.integer :id
      t.string :name
      t.integer :user_id, null: false
      t.integer :server_id, null: false
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
