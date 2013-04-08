class CreateRegisterAbilitySettings < ActiveRecord::Migration
  def change
    create_table :register_ability_settings do |t|
      t.references :ability
      t.string :kind
      t.references :game_data_ability
      t.boolean :pull_down
      t.integer :lv
      t.boolean :setting

      t.timestamps
    end
    add_index :register_ability_settings, :ability_id
    add_index :register_ability_settings, :game_data_ability_id
  end
end
