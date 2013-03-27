class CreateResultTrains < ActiveRecord::Migration
  def change
    create_table :result_trains do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :trainable, :polymorphic => true
      t.integer :count

      t.timestamps
    end
    add_index :result_trains, :character_id
    add_index :result_trains, :day_id
    add_index :result_trains, :trainable_id
  end
end
