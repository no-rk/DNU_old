class CreateResultArts < ActiveRecord::Migration
  def change
    create_table :result_arts do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :art
      t.string :name
      t.text :caption
      t.integer :lv
      t.integer :lv_exp
      t.integer :lv_cap
      t.integer :lv_cap_exp
      t.boolean :forget

      t.timestamps
    end
    add_index :result_arts, :character_id
    add_index :result_arts, :day_id
    add_index :result_arts, :art_id
  end
end
