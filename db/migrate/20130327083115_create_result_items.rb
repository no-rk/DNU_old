class CreateResultItems < ActiveRecord::Migration
  def change
    create_table :result_items do |t|
      t.references :user
      t.references :day
      t.references :way, :polymorphic => true
      t.references :plan
      t.references :type
      t.boolean :dispose_protect
      t.boolean :send_protect
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
