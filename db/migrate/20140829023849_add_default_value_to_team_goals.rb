class AddDefaultValueToTeamGoals < ActiveRecord::Migration
  def change
    change_column :teams, :goals, :integer, default: 0
  end
end
