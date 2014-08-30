class AddTeamIdAndUserIdIndexToPlayers < ActiveRecord::Migration
  def change
    add_index :players, :team_id
    add_index :players, :user_id
  end
end
