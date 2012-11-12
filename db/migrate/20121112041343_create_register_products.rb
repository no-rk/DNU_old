class CreateRegisterProducts < ActiveRecord::Migration
  def change
    create_table :register_products do |t|
      t.references :user

      t.timestamps
    end
    add_index :register_products, :user_id
  end
end
