class AddGameIdIndexToTeams < ActiveRecord::Migration
  def change
    add_index :teams, :game_id
  end
end
