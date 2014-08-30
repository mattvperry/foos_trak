class AddWinnerToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :winner, :boolean, default: false
  end
end
