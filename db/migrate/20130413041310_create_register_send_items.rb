class CreateRegisterSendItems < ActiveRecord::Migration
  def change
    create_table :register_send_items do |t|
      t.references :trade
      t.references :user
      t.integer :number
      t.text :message

      t.timestamps
    end
    add_index :register_send_items, :trade_id
    add_index :register_send_items, :user_id
  end
end
