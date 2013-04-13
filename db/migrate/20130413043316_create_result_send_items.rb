class CreateResultSendItems < ActiveRecord::Migration
  def change
    create_table :result_send_items do |t|
      t.references :passed_day
      t.references :send_item
      t.integer :number
      t.references :item
      t.boolean :success

      t.timestamps
    end
    add_index :result_send_items, :passed_day_id
    add_index :result_send_items, :send_item_id
    add_index :result_send_items, :item_id
  end
end
