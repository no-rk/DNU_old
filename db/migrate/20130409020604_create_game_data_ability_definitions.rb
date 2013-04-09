class CreateGameDataAbilityDefinitions < ActiveRecord::Migration
  def change
    create_table :game_data_ability_definitions do |t|
      t.references :ability
      t.string :kind
      t.integer :lv
      t.text :caption

      t.timestamps
    end
    add_index :game_data_ability_definitions, :ability_id
  end
end
