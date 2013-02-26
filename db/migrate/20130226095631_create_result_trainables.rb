class CreateResultTrainables < ActiveRecord::Migration
  def change
    create_table :result_trainables do |t|
      t.references :user
      t.references :day
      t.references :trainable, :polymorphic => true
      t.integer :lv

      t.timestamps
    end
    add_index :result_trainables, :user_id
    add_index :result_trainables, :day_id
    add_index :result_trainables, :trainable_id
  end
end
