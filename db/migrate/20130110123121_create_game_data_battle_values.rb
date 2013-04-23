class CreateGameDataBattleValues < ActiveRecord::Migration
  def change
    create_table :game_data_battle_values do |t|
      t.string :name
      t.text :caption
      t.boolean :only_caption
      t.boolean :has_max
      t.boolean :has_equip_value

      t.timestamps
    end
  end
end
