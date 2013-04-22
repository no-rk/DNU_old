class CreateGameDataEnemyTerritories < ActiveRecord::Migration
  def change
    create_table :game_data_enemy_territories do |t|
      t.references :landform
      t.references :map
      t.references :map_tip
      t.references :enemy_list
      t.integer :correction
      t.text :definition

      t.timestamps
    end
    add_index :game_data_enemy_territories, :landform_id
    add_index :game_data_enemy_territories, :map_id
    add_index :game_data_enemy_territories, :map_tip_id
    add_index :game_data_enemy_territories, :enemy_list_id
  end
end
