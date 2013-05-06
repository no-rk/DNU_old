class CreateRegisterSupplements < ActiveRecord::Migration
  def change
    create_table :register_supplements do |t|
      t.references :productable, :polymorphic => true
      t.references :art_effect
      t.references :user
      t.integer :material_number
      t.integer :item_number
      t.boolean :experiment
      t.text :message

      t.timestamps
    end
    add_index :register_supplements, :productable_id
    add_index :register_supplements, :art_effect_id
    add_index :register_supplements, :user_id
  end
end
