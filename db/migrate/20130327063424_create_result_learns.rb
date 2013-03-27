class CreateResultLearns < ActiveRecord::Migration
  def change
    create_table :result_learns do |t|
      t.references :character, :polymorphic => true
      t.references :day
      t.references :learnable, :polymorphic => true
      t.boolean :forget

      t.timestamps
    end
    add_index :result_learns, :character_id
    add_index :result_learns, :day_id
    add_index :result_learns, :learnable_id
  end
end
