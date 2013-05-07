class CreateGameDataArtTypes < ActiveRecord::Migration
  def change
    create_table :game_data_art_types do |t|
      t.string :name
      t.text :caption
      t.integer :max
      t.boolean :blossom, :default => false
      t.boolean :forget, :default => false
      t.boolean :lv_cap, :default => false
      t.boolean :train, :default => true
      t.boolean :form, :default => false
      t.boolean :rename, :default => false

      t.timestamps
    end
  end
end
