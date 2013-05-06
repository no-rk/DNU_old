class CreateGameDataBattleTypes < ActiveRecord::Migration
  def change
    create_table :game_data_battle_types do |t|
      t.string :name
      t.text :caption
      t.boolean :normal
      t.boolean :result, :default => false
      t.boolean :rob, :default => false
      t.boolean :escape, :default => false

      t.timestamps
    end
  end
end
