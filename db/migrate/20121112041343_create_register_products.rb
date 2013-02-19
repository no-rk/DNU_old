class CreateRegisterProducts < ActiveRecord::Migration
  def change
    create_table :register_products do |t|
      t.references :user
      t.references :day

      t.timestamps
    end
    add_index :register_products, :user_id
    add_index :register_products, :day_id
  end
end
