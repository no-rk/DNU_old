class CreateResultItemSups < ActiveRecord::Migration
  def change
    create_table :result_item_sups do |t|
      t.references :item
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.string :kind
      t.references :sup
      t.integer :lv
      t.references :source

      t.timestamps
    end
    add_index :result_item_sups, :item_id
    add_index :result_item_sups, :user_id
    add_index :result_item_sups, :day_id
    add_index :result_item_sups, :way_id
    add_index :result_item_sups, :sup_id
    add_index :result_item_sups, :source_id
  end
end
