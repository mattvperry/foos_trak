class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.belongs_to :game
      t.integer :goals

      t.timestamps
    end
  end
end
