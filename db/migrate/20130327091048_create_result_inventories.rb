class CreateResultInventories < ActiveRecord::Migration
  def change
    create_table :result_inventories do |t|
      t.references :passed_day
      t.integer :number
      t.references :item

      t.timestamps
    end
    add_index :result_inventories, :passed_day_id
    add_index :result_inventories, :item_id
  end
end
