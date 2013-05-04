class CreateGameDataCharacterTypes < ActiveRecord::Migration
  def change
    create_table :game_data_character_types do |t|
      t.string :name
      t.text :caption
      t.boolean :player
      t.references :equip

      t.timestamps
    end
    add_index :game_data_character_types, :equip_id
  end
end
