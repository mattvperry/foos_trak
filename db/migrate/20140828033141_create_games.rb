class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :rating_pending

      t.timestamps
    end
  end
end
