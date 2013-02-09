class CreateRegisterBattleSettings < ActiveRecord::Migration
  def change
    create_table :register_battle_settings do |t|
      t.references :battlable, :polymorphic => true

      t.references :skill
      t.integer :priority
      t.string :use_condition
      t.string :use_condition_variable
      t.string :frequency
      t.string :target
      t.string :target_variable
      t.text :message

      t.timestamps
    end
    add_index :register_battle_settings, :battlable_id
    add_index :register_battle_settings, :skill_id
  end
end
