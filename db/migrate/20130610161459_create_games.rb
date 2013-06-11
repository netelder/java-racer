class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :track_length, default: 20
    end
  end
end
