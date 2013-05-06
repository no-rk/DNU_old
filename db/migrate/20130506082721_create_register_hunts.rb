class CreateRegisterHunts < ActiveRecord::Migration
  def change
    create_table :register_hunts do |t|
      t.references :productable, :polymorphic => true
      t.references :art_effect
      t.references :party_member
      t.text :message

      t.timestamps
    end
    add_index :register_hunts, :productable_id
    add_index :register_hunts, :art_effect_id
    add_index :register_hunts, :party_member_id
  end
end
