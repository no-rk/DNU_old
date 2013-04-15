class CreateRegisterAbilityConfs < ActiveRecord::Migration
  def change
    create_table :register_ability_confs do |t|
      t.references :ability
      t.references :game_data_ability
      t.string :kind

      t.timestamps
    end
    add_index :register_ability_confs, :ability_id
    add_index :register_ability_confs, :game_data_ability_id
  end
end
