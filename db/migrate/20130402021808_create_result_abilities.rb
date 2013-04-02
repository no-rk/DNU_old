class CreateResultAbilities < ActiveRecord::Migration
  def change
    create_table :result_abilities do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :ability
      t.string :name
      t.text :caption
      t.integer :lv
      t.integer :lv_exp
      t.integer :lv_cap
      t.integer :lv_cap_exp
      t.boolean :forget

      t.timestamps
    end
    add_index :result_abilities, :character_id
    add_index :result_abilities, :day_id
    add_index :result_abilities, :ability_id
  end
end