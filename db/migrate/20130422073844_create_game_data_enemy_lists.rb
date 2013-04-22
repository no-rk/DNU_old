class CreateGameDataEnemyLists < ActiveRecord::Migration
  def change
    create_table :game_data_enemy_lists do |t|
      t.string :name
      t.text :definition

      t.timestamps
    end
  end
end
