class CreateRegisterArtLvEffects < ActiveRecord::Migration
  def change
    create_table :register_art_lv_effects do |t|
      t.references :art
      t.integer :lv
      t.boolean :setting, :default => true

      t.timestamps
    end
    add_index :register_art_lv_effects, :art_id
  end
end
