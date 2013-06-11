class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.references :player
      t.references :game, unique: true
      t.integer :winner, default: 0
      t.float :time
    end
  end
end
