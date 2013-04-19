class CreateGameDataMapTips < ActiveRecord::Migration
  def change
    create_table :game_data_map_tips do |t|
      t.references :map
      t.integer :x
      t.integer :y
      t.references :landform
      t.boolean :collision
      t.integer :opacity

      t.timestamps
    end
    add_index :game_data_map_tips, :map_id
    add_index :game_data_map_tips, :landform_id
  end
end
