class CreateGameDataBattleSettings < ActiveRecord::Migration
  def change
    create_table :game_data_battle_settings do |t|
      t.string :kind
      t.string :name
      t.text :caption

      t.timestamps
    end
  end
end
