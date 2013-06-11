class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :initials
    end

    add_index :players, :initials, unique: true
  end
end
