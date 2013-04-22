class CreateGameDataEnemyListElements < ActiveRecord::Migration
  def change
    create_table :game_data_enemy_list_elements do |t|
      t.references :enemy_list
      t.references :character
      t.integer :correction
      t.float :frequency

      t.timestamps
    end
    add_index :game_data_enemy_list_elements, :enemy_list_id
    add_index :game_data_enemy_list_elements, :character_id
  end
end
