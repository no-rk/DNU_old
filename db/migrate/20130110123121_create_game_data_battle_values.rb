class CreateGameDataBattleValues < ActiveRecord::Migration
  def change
    create_table :game_data_battle_values do |t|
      t.string :name
      t.text :caption

      t.timestamps
    end
  end
end
