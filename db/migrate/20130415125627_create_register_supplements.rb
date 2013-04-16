class CreateRegisterSupplements < ActiveRecord::Migration
  def change
    create_table :register_supplements do |t|
      t.references :product
      t.references :user
      t.integer :material_number
      t.integer :item_number
      t.boolean :experiment
      t.text :message

      t.timestamps
    end
    add_index :register_supplements, :product_id
    add_index :register_supplements, :user_id
  end
end
