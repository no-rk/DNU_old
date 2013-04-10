class CreateResultTrains < ActiveRecord::Migration
  def change
    create_table :result_trains do |t|
      t.references :user
      t.references :day
      t.references :trainable, :polymorphic => true
      t.integer :from
      t.integer :to
      t.boolean :success

      t.timestamps
    end
    add_index :result_trains, :user_id
    add_index :result_trains, :day_id
    add_index :result_trains, :trainable_id
  end
end
