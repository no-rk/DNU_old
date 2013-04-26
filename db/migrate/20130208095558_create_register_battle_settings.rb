class CreateRegisterBattleSettings < ActiveRecord::Migration
  def change
    create_table :register_battle_settings do |t|
      t.references :battlable, :polymorphic => true

      t.references :skill
      t.integer :priority
      t.references :use_condition
      t.integer :use_condition_variable
      t.references :frequency
      t.references :target
      t.integer :target_variable
      t.text :condition
      t.text :message

      t.timestamps
    end
    add_index :register_battle_settings, :battlable_id
    add_index :register_battle_settings, :skill_id
    add_index :register_battle_settings, :use_condition_id
    add_index :register_battle_settings, :frequency_id
    add_index :register_battle_settings, :target_id
  end
end
