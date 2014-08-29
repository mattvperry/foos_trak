class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.integer :position
      t.decimal :skill_mean
      t.decimal :skill_deviation

      t.timestamps
    end
  end
end
