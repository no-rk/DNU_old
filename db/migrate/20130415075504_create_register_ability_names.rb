class CreateRegisterAbilityNames < ActiveRecord::Migration
  def change
    create_table :register_ability_names do |t|
      t.references :ability_conf
      t.string :name
      t.text :caption

      t.timestamps
    end
    add_index :register_ability_names, :ability_conf_id
  end
end
