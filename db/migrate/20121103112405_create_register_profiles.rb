class CreateRegisterProfiles < ActiveRecord::Migration
  def change
    create_table :register_profiles do |t|
      t.references :character, :polymorphic => true

      t.string :name
      t.string :nickname
      t.string :race
      t.string :gender
      t.string :age
      t.text :introduction

      t.timestamps
    end
    add_index :register_profiles, :character_id
  end
end
