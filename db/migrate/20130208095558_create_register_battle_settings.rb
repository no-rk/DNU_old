class CreateRegisterBattleSettings < ActiveRecord::Migration
  def change
    create_table :register_battle_settings do |t|
      t.references :battle

      t.references :usable, :polymorphic => true
      t.integer :priority
      t.string :use_condition
      t.string :use_condition_variable
      t.string :frequency
      t.string :target
      t.string :target_variable
      t.text :message

      t.timestamps
    end
    add_index :register_battle_settings, :battle_id
    add_index :register_battle_settings, :usable_id
  end
end
