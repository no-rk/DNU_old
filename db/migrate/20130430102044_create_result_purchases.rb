class CreateResultPurchases < ActiveRecord::Migration
  def change
    create_table :result_purchases do |t|
      t.references :passed_day
      t.references :purchase
      t.integer :number
      t.references :item
      t.boolean :success

      t.timestamps
    end
    add_index :result_purchases, :passed_day_id
    add_index :result_purchases, :purchase_id
    add_index :result_purchases, :item_id
  end
end
