class CreateRegisterProfiles < ActiveRecord::Migration
  def change
    create_table :register_profiles do |t|
      t.string :name
      t.string :nickname
      t.string :race
      t.string :gender
      t.string :age
      t.text :introduction
      t.references :character, :polymorphic => true

      t.timestamps
    end
    add_index :register_profiles, :character_id
    add_index :register_profiles, :character_type
  end
end
