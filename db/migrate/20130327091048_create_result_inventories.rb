class CreateResultInventories < ActiveRecord::Migration
  def change
    create_table :result_inventories do |t|
      t.references :user
      t.references :day
      t.integer :number
      t.references :item

      t.timestamps
    end
    add_index :result_inventories, :user_id
    add_index :result_inventories, :day_id
    add_index :result_inventories, :item_id
  end
end
