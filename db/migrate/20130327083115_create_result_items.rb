class CreateResultItems < ActiveRecord::Migration
  def change
    create_table :result_items do |t|
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.references :plan, :polymorphic => true
      t.references :type, :polymorphic => true
      t.boolean :protect
      t.references :source

      t.timestamps
    end
    add_index :result_items, :user_id
    add_index :result_items, :day_id
    add_index :result_items, :way_id
    add_index :result_items, :plan_id
    add_index :result_items, :type_id
    add_index :result_items, :source_id
  end
end
