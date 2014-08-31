class AddIndiciesAndDefaultsToGamesAndPlayers < ActiveRecord::Migration
  def change
    add_index :players, :created_at
    add_index :games, :created_at
    change_column :games, :rating_pending, :boolean, default: true
  end
end
