class CreateRegisterProductPermissions < ActiveRecord::Migration
  def change
    create_table :register_product_permissions do |t|
      t.references :product
      t.references :user

      t.timestamps
    end
    add_index :register_product_permissions, :product_id
    add_index :register_product_permissions, :user_id
  end
end
