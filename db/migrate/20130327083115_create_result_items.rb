class CreateResultItems < ActiveRecord::Migration
  def change
    create_table :result_items do |t|
      t.references :user
      t.references :day
      t.references :makable, :polymorphic => true
      t.boolean :protect
      t.references :item

      t.timestamps
    end
    add_index :result_items, :user_id
    add_index :result_items, :day_id
    add_index :result_items, :makable_id
    add_index :result_items, :item_id
  end
end
