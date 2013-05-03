class CreateRegisterForges < ActiveRecord::Migration
  def change
    create_table :register_forges do |t|
      t.references :product
      t.references :art_effect
      t.references :user
      t.integer :number
      t.references :item_type
      t.boolean :experiment
      t.string :name
      t.text :caption
      t.text :message

      t.timestamps
    end
    add_index :register_forges, :product_id
    add_index :register_forges, :art_effect_id
    add_index :register_forges, :user_id
    add_index :register_forges, :item_type_id
  end
end
