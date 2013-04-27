class CreateRegisterItemSkillSettings < ActiveRecord::Migration
  def change
    create_table :register_item_skill_settings do |t|
      t.references :battlable, :polymorphic => true
      t.integer :number
      t.references :item
      t.integer :priority
      t.references :use_condition
      t.integer :use_condition_variable
      t.references :frequency
      t.text :condition
      t.text :message

      t.timestamps
    end
    add_index :register_item_skill_settings, :battlable_id
    add_index :register_item_skill_settings, :item_id
    add_index :register_item_skill_settings, :use_condition_id
    add_index :register_item_skill_settings, :frequency_id
  end
end
