class CreateResultItemNames < ActiveRecord::Migration
  def change
    create_table :result_item_names do |t|
      t.references :item
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.string :name
      t.text :caption
      t.references :source

      t.timestamps
    end
    add_index :result_item_names, :item_id
    add_index :result_item_names, :user_id
    add_index :result_item_names, :day_id
    add_index :result_item_names, :way_id
    add_index :result_item_names, :source_id
  end
end
