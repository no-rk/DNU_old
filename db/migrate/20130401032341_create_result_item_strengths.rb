class CreateResultItemStrengths < ActiveRecord::Migration
  def change
    create_table :result_item_strengths do |t|
      t.references :item
      t.references :user
      t.references :day
      t.references :makable, :polymorphic => true
      t.integer :strength
      t.references :source

      t.timestamps
    end
    add_index :result_item_strengths, :item_id
    add_index :result_item_strengths, :user_id
    add_index :result_item_strengths, :day_id
    add_index :result_item_strengths, :makable_id
    add_index :result_item_strengths, :source_id
  end
end
