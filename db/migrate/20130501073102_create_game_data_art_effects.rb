class CreateGameDataArtEffects < ActiveRecord::Migration
  def change
    create_table :game_data_art_effects do |t|
      t.references :art
      t.string :kind
      t.string :name
      t.boolean :forgeable, :default => false
      t.text :definition
      t.text :tree

      t.timestamps
    end
    add_index :game_data_art_effects, :art_id
  end
end
