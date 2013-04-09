class CreateRegisterAbilitySettings < ActiveRecord::Migration
  def change
    create_table :register_ability_settings do |t|
      t.references :ability
      t.string :kind
      t.references :ability_definition
      t.boolean :setting

      t.timestamps
    end
    add_index :register_ability_settings, :ability_id
    add_index :register_ability_settings, :ability_definition_id
  end
end
