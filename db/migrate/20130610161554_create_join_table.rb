class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.references :player
      t.references :game
      t.float :time
    end
  end
end
