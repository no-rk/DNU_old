class CreateRegisterPurchases < ActiveRecord::Migration
  def change
    create_table :register_purchases do |t|
      t.references :event
      t.references :item
      t.references :point
      t.integer :price

      t.timestamps
    end
    add_index :register_purchases, :event_id
    add_index :register_purchases, :item_id
    add_index :register_purchases, :point_id
  end
end
