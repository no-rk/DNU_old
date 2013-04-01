class CreateResultItemElements < ActiveRecord::Migration
  def change
    create_table :result_item_elements do |t|
      t.references :item
      t.references :user
      t.references :day
      t.references :makable, :polymorphic => true
      t.references :element

      t.timestamps
    end
    add_index :result_item_elements, :item_id
    add_index :result_item_elements, :user_id
    add_index :result_item_elements, :day_id
    add_index :result_item_elements, :makable_id
    add_index :result_item_elements, :element_id
  end
end
