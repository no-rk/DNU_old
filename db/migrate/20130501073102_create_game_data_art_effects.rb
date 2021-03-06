class CreateGameDataArtEffects < ActiveRecord::Migration
  def change
    create_table :game_data_art_effects do |t|
      t.references :art
      t.string :kind
      t.string :name
      t.boolean :lv_effect, :default => false
      t.boolean :pull_down, :default => false
      t.boolean :forgeable, :default => false
      t.boolean :supplementable, :default => false
      t.boolean :huntable, :default => false
      t.text :definition
      t.text :tree

      t.timestamps
    end
    add_index :game_data_art_effects, :art_id
  end
end
