class CreateGameDataBattleValues < ActiveRecord::Migration
  def change
    create_table :game_data_battle_values do |t|
      t.references :source, :polymorphic => true
      t.string :name
      t.text :caption
      t.integer :min
      t.integer :max
      t.boolean :has_max, :default => false
      t.boolean :has_equip_value, :default => false

      t.timestamps
    end
    add_index :game_data_battle_values, :source_id
  end
end
