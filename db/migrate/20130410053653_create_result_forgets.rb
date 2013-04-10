class CreateResultForgets < ActiveRecord::Migration
  def change
    create_table :result_forgets do |t|
      t.references :user
      t.references :day
      t.references :forgettable, :polymorphic => true
      t.boolean :success

      t.timestamps
    end
    add_index :result_forgets, :user_id
    add_index :result_forgets, :day_id
    add_index :result_forgets, :forgettable_id
  end
end
